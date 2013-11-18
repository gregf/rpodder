module Rpodder
  class Runner
    def initialize(*args)
        parse_options
    end

    def parse_options
      trap_interrupt
      Rpodder::CLI.start
    end

    def trap_interrupt
      Signal.trap('INT') do
        $stderr.puts "\n\nCaught Ctrl-C, exiting!"
        exit 1
      end
    end
  end
end
