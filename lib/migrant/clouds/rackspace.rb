module Migrant
  module Clouds
    class Rackspace < Base
      register 'rackspace'

      def initialize(env)
        super
      end

      def connect
        @connection = Fog::Compute.new(:provider => 'Rackspace', 
                                      :rackspace_api_key => @environment.setting('provider.api_key'),
                                      :rackspace_username => @environment.setting('provider.user_name'))
      end

      def log_server_info
        super
        @environment.ui.notice "  Name:       #{@environment.server.name}"
        @environment.ui.notice "  IP Address: #{@environment.server.addresses['public']}"
        @environment.ui.notice "  Image ID:   #{@environment.server.image.name}"
        @environment.ui.notice "  Flavor:     #{@environment.server.flavor.name}"
      end
    end
  end
end
