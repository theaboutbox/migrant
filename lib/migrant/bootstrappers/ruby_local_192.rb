module Migrant
  module Bootstrappers
    # Installs Ruby 1.9.2 into /usr/local
    class RubyLocal192 < Base
      register(:rbenv_192)
      default_bootstrapper

      def initialize(env)
        super
      end

      def run
        commands = [
          'sudo apt-get update',
          'sudo apt-get install -y build-essential wget build-essential bison openssl libreadline5 libreadline-dev ' +
          'curl git-core zlib1g zlib1g-dev libssl-dev vim libsqlite3-0 libsqlite3-dev ' +
          'sqlite3 libreadline-dev libxml2-dev autoconf',
          'rm -rf /tmp/ruby-build',
          'git clone git://github.com/theaboutbox/ruby-build.git /tmp/ruby-build',
          'cd /tmp/ruby-build && sudo ./install.sh',
          'sudo ruby-build 1.9.2-p290 /usr/local',
          'sudo gem install bundler chef'
        ]
        @environment.cloud.execute commands
      end

      def bootstrapped?
        result = @environment.server.ssh('/usr/local/bin/chef-solo --version')
        result[0].status == 0
      end
    end
  end
end
