require 'thor'
require 'pp'
module Migrant
  class CLI < Thor
    desc 'init', 'Creates a Migrantfile with basic information'
    def init

    end

    desc 'up', 'Starts the environment based on the information in the Migrantfile'
    def up
      load_config
      @environment.up
    end

    desc 'destroy','Shut down the servers based on the information in this Migrantfile'
    def destroy
      load_config
      @environment.destroy
    end

    desc 'info','Describe any currently running instances'
    def info
      load_config
      @environment.info
    end

    no_tasks do
      def load_config
        @environment = Environment.new
      end
    end
  end
end

