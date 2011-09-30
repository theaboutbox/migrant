module Migrant
  module Configuration
    class AWS
      attr_accessor :access_key
      attr_accessor :secret_key
    end
    class Rackspace
      attr_accessor :username
      attr_accessor :api_key
    end
  end

  class Config
    attr_accessor :provider
    attr_accessor :ssh_public_key
    attr_accessor :ssh_private_key

    class << self
      def run(&block)
        @@config ||= Migrant::Config.new
        yield @@config
      end

      def configuration
        @@config
      end
    end
    
    def aws
      @aws ||= Migrant::Configuration::AWS.new
      @aws
    end
    
    def rackspace
      @rackspace ||= Migrant::Configuration::Rackspace.new
      @rackspace
    end
  end
end
