module Migrant
  module Clouds
    class Rackspace < Base
      register :rackspace

      def initialize(env,config)
        super
      end

      def connect
        @connection = Fog::Compute.new(:provider => 'Rackspace', 
                                      :rackspace_api_key => @environment.config.rackspace.api_key,
                                      :rackspace_username => @environment.config.rackspace.username)
      end
    end
  end
end
