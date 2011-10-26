require 'vagrant'

module Migrant
  module Provisioners
    class ChefSolo < Base
      include Util

      register :chef_solo
      def initialize(env)
        super
      end
      def prepare
      end
      def upload
        server = @environment.server
        vagrant_environment = Vagrant::Environment.new
        vagrant_provisioner_config = vagrant_environment.config.vm.provisioners.first.config
        cookbook_paths = vagrant_provisioner_config.cookbooks_path
        roles_path = vagrant_provisioner_config.roles_path

        # Delete old stuff
        server.ssh "rm -rf /tmp/migrant && mkdir -p /tmp/migrant"
        
        @environment.ui.info "Uploading Cookbooks"
        cookbook_dest_paths = []
        cookbook_paths.each do |path|
          dest_path = "/tmp/migrant/#{File.basename(path)}"
          server.scp path, dest_path, :recursive => true
          cookbook_dest_paths << dest_path
        end
        role_dest_paths = []
        dest_path = "/tmp/migrant/#{File.basename(roles_path)}"
        server.scp roles_path, dest_path, :recursive => true
        role_dest_paths << dest_path

        @environment.ui.info "Generating Chef Solo Config Files"
        File.open('/tmp/migrant-solo.rb','w') do |f|
          f.write(TemplateRenderer.render('chef/solo.rb', {
            :cookbook_path => cookbook_dest_paths,
            :role_path => role_dest_paths
          }))
        end
        server.scp "/tmp/migrant-solo.rb","/tmp/migrant/solo.rb"
        File.open('/tmp/migrant-dna.json','w') do |f|
          f.write(TemplateRenderer.render('chef/dna.json', {
            :run_list => vagrant_provisioner_config.run_list
          }))
        end
        server.scp "/tmp/migrant-dna.json","/tmp/migrant/dna.json"
      end
      
      def run
        @environment.cloud.execute(['sudo chef-solo -c /tmp/migrant/solo.rb -j /tmp/migrant/dna.json'])
      end
    end
  end
end
