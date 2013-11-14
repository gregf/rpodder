module Rpodder
  class Runner < Configurator
    include Rpodder

    def initialize(*args)
      parse_options
    end

    String.class_eval do
      def strip_heredoc_with_indent(indent=0)
      new_indent = ( self.empty? ? 0 : ( scan(/^[ \t]*(?=\S)/).min.size - indent ) )
      gsub(/^[ \t]{#{new_indent}}/, '')
      end
    end

    def parse_options
      doc = <<-DOCOPT.strip_heredoc_with_indent
      Rpodder.

      Usage:
        #{__FILE__} fetch
        #{__FILE__} update
        #{__FILE__} download
        #{__FILE__} lscasts
        #{__FILE__} lseps
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
        Rpodder::Update.new
        Rpodder::Download.new
      end

      if @args['lscasts']
        Rpodder::List_podcasts.new
      end

      if @args['lseps']
        Rpodder::List_episodes.new
      end

      if @args['download']
        Rpodder::Download.new
      end

      if @args['update']
        Rpodder::Update.new
      end

      if @args['opml']
        Rpodder::Import.new(@args)
      end
    end

    def trap_interrupt
      Signal.trap("INT") do
        $stderr.puts "\n\nCaught Ctrl-C, cleaning up, and exiting!"
        exit(1)
      end
    end
  end
end
