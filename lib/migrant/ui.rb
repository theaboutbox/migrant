module Migrant
  # Handles displaying messages to the user.
  class UI
    # shell - a Thor::Shell instance
    def initialize(shell)
      @shell = shell
    end
    def info(msg)
      @shell.say(msg,nil)
    end
    def warn(msg)
      @shell.say(msg,:yellow)
    end
    def error(msg)
      @shell.say(msg,:red)
    end
    def notice(msg)
      @shell.say(msg,:green)
    end
    def yes?(msg,opts)
      @shell.yes?(msg,opts)
    end
  end
end
