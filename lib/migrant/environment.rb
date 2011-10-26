require 'fileutils'
require 'configuration'
require 'thor'
module Migrant

  # Holds all the state for this run of Migrant
  class Environment
    DEFAULT_DATA_PATH = 'data'
    DEFAULT_BOXES_PATH = File.join(DEFAULT_DATA_PATH,'migrant_boxes.yml')

    def initialize(environment_name,config=nil)
      @ui = Migrant::UI.new(::Thor::Base.shell.new)
      @environment_name = environment_name
      if config
        @config = config
      else
        Kernel.load 'Migrantfile'
        @config = Configuration.for('migrant')
      end
      if @environment_name.nil?
        @ui.notice "Using default environment"
      elsif @config.include?(@environment_name.to_sym)
        @ui.notice "Using #{@environment_name} environment"
      else
        @ui.error "#{@environment_name} environment is not defined in the configuration file"
        raise "Environment #{@environment_name} not found"
      end

      cloud_class = Migrant::Clouds::Base.registered(setting('provider.name'))
      raise "Cannot find cloud '#{setting('provider.name')}'" if cloud_class.nil?
      @cloud = cloud_class.new(self)
      @bootstrapper = Migrant::Bootstrappers::Base.default.new(self)
      @provisioner = Migrant::Provisioners::Base.registered(:chef_solo).new(self)
      FileUtils.mkdir_p DEFAULT_DATA_PATH unless File.exists?(DEFAULT_DATA_PATH)
      @boxes = Boxes.new(DEFAULT_BOXES_PATH).load
    end

    # Retrieve a setting by name. First try within the context of the current environment.
    # If the property does not exist there, look in the default property definitions
    def setting(name)
      roots = []
      if @environment_name
        roots << @config.send(@environment_name)
      end
      roots << @config
      roots.each do |root|
        begin
          setting_value = name.split('.').inject(root) { |node,prop| if node.include?(prop.to_sym) then node.send(prop) else raise "Undefined property #{prop} for #{node.name}" end}
          return setting_value
        rescue => e
          # Fall through to next case
        end
      end
      # If we get here the property does not exist
      #XXX - should probably ask for a default, and if one is not provided, raise an error
      nil
    end

    def up
      connect
      init_server
      bootstrap
      provision
    end

    def connect
      ui.warn "Connecting to #{setting('provider.name')}"
      @cloud.connect
    end

    def launch!
      @cloud.bootstrap_server
      @boxes.add(@environment_name,setting('provider.name'),@server.id)
      @boxes.save

      # persist metadata about server so we can load it later
      @cloud.execute ['pwd']
    end

    # If the server exists, connect to it. If not, bootstrap it
    def init_server
      box = @boxes[@environment_name]
      if box.nil?
        launch!
      else
        @cloud.connect_to_server(box)
      end
    end

    def info
      box = @boxes.first
      if box.nil?
        @ui.info "There are no boxes running"
      else
        connect
        @cloud.connect_to_server(box)
        @cloud.log_server_info
      end
    end

    def bootstrap
      @bootstrapper.run unless @bootstrapper.bootstrapped?
    end

    def provision
      @provisioner.upload
      @provisioner.prepare
      @provisioner.run
    end

    def destroy
      box = @boxes.first

      if box.nil?
        @ui.error "There are currently no boxes running"
      else
        if @cloud.destroy(box)
          FileUtils.rm DEFAULT_BOXES_PATH
        end
      end
    end

    attr_accessor :server
    attr_reader :ui
    attr_reader :cloud
  end
end
