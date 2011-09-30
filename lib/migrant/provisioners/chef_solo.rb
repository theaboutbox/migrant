module Migrant
  module Provisioners
    class ChefSolo < Base
      include Util

      register :chef_solo
      def initialize(env,config)
        super
      end
      def prepare
      end
      def upload
        server = @environment.server

        # Delete old stuff
        server.ssh "rm -rf /tmp/migrant && mkdir -p /tmp/migrant"
        
        #XXX Get the config settings from the Vagrant config files
        @environment.ui.info "Generating Chef Solo Config Files"
        File.open('/tmp/migrant-solo.rb','w') do |f|
          f.write(TemplateRenderer.render('chef/solo.rb', {
            :test => :test
          }))
        end
        server.scp "/tmp/migrant-solo.rb","/tmp/migrant/solo.rb"
        File.open('/tmp/migrant-dna.json','w') do |f|
          f.write(TemplateRenderer.render('chef/dna.json', {
            :test => :test
          }))
        end
        server.scp "/tmp/migrant-dna.json","/tmp/migrant/dna.json"
        ['cookbooks','site-cookbooks','roles'].each do |dir|
          server.scp "./#{dir}","/tmp/migrant/#{dir}", {:recursive => true}
        end
      end
      def run
        @environment.cloud.execute(['sudo chef-solo -c /tmp/migrant/solo.rb -j /tmp/migrant/dna.json'])
      end
    end
  end
end
