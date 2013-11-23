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
      podcasts = Podcast.rssurls
      podcasts.each do |pcast|
        Podcast.all(:rssurl => pcast.rssurl.to_s).destroy unless urls.include?(pcast.rssurl.to_s)
      end
    end

  end
end
