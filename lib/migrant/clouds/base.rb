require 'fog'
module Migrant
  module Clouds
    
    # Base class for cloud service providers.
    # All service providers use Fog to handle bootstrapping servers and running stuff
    # Cloud service providers are responsible for starting up the server, setting up ssh
    # access with the provided keypair, and (eventually) disabling the root user.
    class Base
      
      # Register a provider
      def self.register(shortcut)
        @@clouds ||= {}
        @@clouds[shortcut] = self
      end

      # Get a registered provider
      def self.registered(shortcut)
        @@clouds[shortcut]
      end

      def initialize(env)
        @environment = env
        @server_def = {:private_key_path => @environment.setting('ssh.private_key'),
          :public_key_path => @environment.setting('ssh.public_key')}
        flavor_id = @environment.setting('provider.flavor_id')
        @server_def[:flavor_id] = flavor_id unless flavor_id.nil?
        image_id = @environment.setting('provider.image_id')
        @server_def[:image_id] = image_id unless image_id.nil?
      end

      attr_accessor :connection

      def connect
        raise "Invalid Action for Base Class"
      end

      def bootstrap_server
        @environment.ui.info "Launching Server..."
        @environment.server = @connection.servers.bootstrap(@server_def)
        @environment.ui.notice "Server Launched!"
        ip_address = @environment.setting('provider.ip_address')
        unless ip_address.nil?
          @connection.associate_address(@environment.server.id,ip_address)
        end
        log_server_info
      end

      def log_server_info
        @environment.ui.notice "  ID:         #{@environment.server.id}"
      end

      # Set up connection information for a server and set up SSH keypair access
      #
      # box   -   Migrant::Box object with information about the server to connect to
      #
      # Does not return anything but sets up @environment.server
      def connect_to_server(box)
        @environment.ui.notice "Connecting to #{box.provider.to_s} server: #{box.id}"
        @environment.server = @connection.servers.get(box.id)
        if (@environment.server.nil?)
          @environment.ui.error "Cannot connect to server!"
          raise "Cannot find server"
        end
        @environment.server.merge_attributes(@server_def)
      end

      def execute(commands)
        server = @environment.server
        commands.each do |cmd|
          @environment.ui.info("$ #{cmd}")
          result = server.ssh cmd
          if (result[0].status != 0)
            @environment.ui.info(result[0].stdout)
            @environment.ui.error "Error executing command: #{cmd}\n#{result.inspect}"
            raise "Remote Script Error"
          end
          @environment.ui.info(result[0].stdout)
          @environment.ui.warn(result[0].stderr) if result[0].stderr
        end
      end

      # Asks the user if they want to shut down a box
      # 
      # box - A Migrant::Box with information about the box
      #
      # returns true if the user decided to shut down the box
      def destroy(box)
        if (@environment.ui.yes?("Are you sure you want to shut down box #{box.name}?",:red))
          @environment.ui.notice "Shutting down box #{box.name} id: #{box.id}"
          connect
          @connection.servers.get(box.id).destroy
          return true
        end
        return false
      end
    end
  end
end
