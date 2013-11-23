module Rpodder
  class Download < Base
    def initialize
      super
      download_episodes
    end

    def download_episodes
      Episode.new_episodes.each do |ep|
        begin
          Rpodder::Downloader.new(ep)
        rescue => e
          puts e
        else
          ep.mark_as_downloaded
        end
      end
    end
  end
end
