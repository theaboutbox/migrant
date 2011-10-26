module Migrant
  module Clouds
    class AWS < Base
      register 'aws'

      def initialize(env)
        super
        @server_def[:username] = 'ubuntu'
        @server_def[:groups] = ['d2-server']
        
      end

      def connect
        @connection = Fog::Compute.new(:provider => 'AWS',
                                       :aws_access_key_id => @environment.setting('provider.access_key'),
                                       :aws_secret_access_key => @environment.setting('provider.secret_key'))
      end

      def log_server_info
        super
        @environment.ui.notice "  Flavor:     #{@environment.server.flavor.name}"
        @environment.ui.notice "DNS Name:     #{@environment.server.dns_name}"
        @environment.ui.notice "    Zone:     #{@environment.server.availability_zone}"
      end

    end
  end
end
