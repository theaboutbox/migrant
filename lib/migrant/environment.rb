require 'fileutils'
module Migrant

  # Holds all the state for this run of Migrant
  class Environment
    DEFAULT_DATA_PATH = 'data'
    DEFAULT_BOXES_PATH = File.join(DEFAULT_DATA_PATH,'migrant_boxes.yml')

    def initialize
      Kernel.load 'Migrantfile'
      @config = Migrant::Config.configuration
      @ui = Migrant::UI.new(Thor::Base.shell.new)
      @cloud = Migrant::Clouds::Base.registered(@config.provider).new(self,@config)
      @bootstrapper = Migrant::Bootstrappers::Base.default.new(self,@config)
      @provisioner = Migrant::Provisioners::Base.registered(:chef_solo).new(self,@config)
      FileUtils.mkdir_p DEFAULT_DATA_PATH unless File.exists?(DEFAULT_DATA_PATH)
      @boxes = Boxes.load(DEFAULT_BOXES_PATH)
    end

    def config
      @config
    end

    def up
      connect
      init_server
      bootstrap
      provision
    end

    def connect
      ui.warn "Connecting to #{@config.provider.to_s}"
      @cloud.connect
    end

    def launch!
      @cloud.bootstrap_server
      @boxes.add(@config.provider,@server.id,@server.name)
      @boxes.save

      # persist metadata about server so we can load it later
      @cloud.execute ['pwd']
    end

    # If the server exists, connect to it. If not, bootstrap it
    def init_server
      box = @boxes.first
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
