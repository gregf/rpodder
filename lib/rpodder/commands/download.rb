module Rpodder
  class Download < Base
    def initialize
      super
      download_episodes
    end

    def new_episodes
      Episode.all(:downloaded => false, :podcast => { :paused => false })
    end

    def download_episodes
      new_episodes.each do |ep|
        Rpodder::Downloader.new(ep)
      end
    end
  end
end
