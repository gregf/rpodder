module Rpodder
  class Runner < Base
    def initialize(*args)
      load_database!
      parse_options
    end

    def parse_options
      trap_interrupt
      Rpodder::CLI.start
      remove_unused!
    end

    def trap_interrupt
      Signal.trap('INT') do
        error "\n\nCaught Ctrl-C, exiting!"
        exit 1
      end
    end

    def remove_unused!
      podcasts_to_remove.each do |pcast|
        say "Removing unused #{pcast}"
        Podcast.all(:rssurl => pcast).destroy
      end
    end

    protected

    def podcasts_to_remove
      podcasts - urls
    end
  end
end
