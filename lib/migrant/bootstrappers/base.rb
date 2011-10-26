module Migrant
  module Bootstrappers
    # Base class for all boostrappers.
    class Base

      def self.register(shortcut)
        @@bootstrappers ||= Hash.new
        @@bootstrappers[shortcut] = self
      end

      def self.registered(shortcut)
        @@bootstrappers[shortcut]
      end
      
      def self.default_bootstrapper
        @@default = self
      end

      def self.default
        @@default
      end
      
      def initialize(env)
        @environment = env
      end

      # Run the bootstrapping process
      def run
        raise "Invalid Bootstrapper"
      end

      # Returns true if the box is already bootstrapped
      def bootstrapped?
        raise "Invalid Bootstrapper"
      end
    end
  end
end
