module Migrant
  module Provisioners
    class Base
      def self.register(shortcut)
        @@provisioners ||= {}
        @@provisioners[shortcut] = self
      end

      def self.registered(shortcut)
        @@provisioners[shortcut]
      end
      
      def initialize(env,config)
        @environment = env
        @config = config
      end

      # Upload any necessary files
      def upload
        raise "invalid provisioner"
      end

      # Any pre-provisioning preparation
      def prepare
        raise "invalid provisioner"
      end

      # Run the provisioner
      def run
        raise "invalide provisioner"
      end
    end
  end
end
