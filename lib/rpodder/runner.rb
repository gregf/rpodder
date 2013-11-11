module Rpodder
  class Runner

    def initialize(*args)
      parse_options
    end

    def parse_options
      doc = <<DOCOPT
Rpodder.

Usage:
  #{__FILE__} fetch
  #{__FILE__} import opml <url>
  #{__FILE__} -h | --help
  #{__FILE__} -V | --version
  #{__FILE__} -q | --quiet

Options:
  -h --help     Show this screen.
  -V --version  Show version.
  -q --quiet    Quiet

DOCOPT
      begin
        @args = Docopt::docopt(doc, version: Rpodder::VERSION)
        run
      rescue Docopt::Exit => e
        puts e.message
      end
    end

    def run
      trap_interrupt

      if @args['fetch']
        Rpodder::Fetch.new
      end

      if @args['import']
        Rpodder::Import.new
      end
    end

    def trap_interrupt
      Signal.trap("INT") do
        $stderr.puts "\n\nCaught Ctrl-C, cleaning up, and exiting!"
        #cleanup
        exit(1)
      end
    end
  end
end
