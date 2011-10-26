require 'thor'
require 'pp'
module Migrant
  class CLI < Thor
    desc 'init', 'Creates a Migrantfile with basic information'
    def init

    end

    desc 'up', 'Starts the environment based on the information in the Migrantfile'
    method_option :environment, :aliases => '-e', :desc => 'Specify an environment to launch boxes'
    def up
      load_config(options.environment)
      @environment.up
    end

    desc 'destroy','Shut down the servers based on the information in this Migrantfile'
    method_option :environment, :aliases => '-e', :desc => 'Specify an environment to destroy boxes'
    def destroy
      load_config(options.environment)
      @environment.destroy
    end

    desc 'info','Describe any currently running instances'
    method_option :environment, :aliases => '-e', :desc => 'Specify an environment to destroy boxes'
    def info
      load_config(options.environment)
      @environment.info
    end

    no_tasks do
      def load_config(environment_name)
        @environment = Environment.new(environment_name)
      end

    end
  end
end

