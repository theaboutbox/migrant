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

      def initialize(env,config)
        @environment = env
        @config = config
      end

      attr_accessor :connection

      def connect
        raise "Invalid Action for Base Class"
      end

      def bootstrap_server
        @environment.ui.info "Launching Server..."
        @environment.server = @connection.servers.bootstrap(
          :private_key_path => @config.ssh_private_key,
          :public_key_path => @config.ssh_public_key)
        @environment.ui.notice "Server Launched!"
        log_server_info
      end

      def log_server_info
        @environment.ui.notice "  ID:         #{@environment.server.id}"
        @environment.ui.notice "  Name:       #{@environment.server.name}"
        @environment.ui.notice "  IP Address: #{@environment.server.addresses['public']}"
        @environment.ui.notice "  Image ID:   #{@environment.server.image.name}"
        @environment.ui.notice "  Flavor:     #{@environment.server.flavor.name}"
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
        @environment.server.private_key_path = @config.ssh_private_key
        @environment.server.public_key_path = @config.ssh_public_key
      end

      def execute(commands)
        server = @environment.server
        commands.each do |cmd|
          @environment.ui.info("$ #{cmd}")
          result = server.ssh cmd
          if (result[0].status != 0)
            @environment.ui.error "Error executing command: #{cmd}\n#{result[0].stderr}"
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
