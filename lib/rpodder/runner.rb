module Rpodder
  class Runner < Base
    def initialize(*args)
      load_config!
      load_database!
      parse_options
    end

    def parse_options
      trap_interrupt
      Rpodder::CLI.start
      remove_unused!
      clean_history
    end

    def trap_interrupt
      Signal.trap('INT') do
        error "\n\nCaught Ctrl-C, exiting!"
        exit 1
      end
    end

    def clean_history
      podcasts = Podcast.all
      limit = @conf['max-items'] * 100
      offset = @conf['max-items']
      podcasts.each { |pcast| pcast.episodes.all(:limit => limit, :offset => offset).destroy }
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
