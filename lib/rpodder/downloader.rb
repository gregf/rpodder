module Rpodder
  class Downloader < Configurator
    attr_reader :url
    attr_reader :file
    attr_reader :podcast_title
    attr_reader :youtube
    attr_reader :podcasts_directory
    attr_reader :output

    def initialize(episode)
      super

      @url                = episode.enclosure_url
      @file               = get_filename(@url)
      @podcast_title      = format_title(episode.podcast.title)
      @youtube            = @url.to_s.include?('youtube.com')
      @podcasts_directory = File.expand_path(@conf['download'])
      @output             = File.join(@podcasts_directory, @podcast_title, @file)

      create_dir File.join(@podcasts_directory, @podcast_title) unless @youtube
      download
    end

    def download
      begin
        if youtube
          system %Q{youtube-dl -f #{@conf['youtube-quality']} --no-playlist --continue --no-part -o "#{podcasts_directory}/%(uploader)s/%(title)s.%(ext)s" "#{url}"}
        else
          system %Q{wget -c #{url} -O "#{output}"}
        end
      rescue => e
        puts "Failed to download #{url}"
        puts e
      else
        episode.mark_as_downloaded
      end
    end

    private

    def format_title(title)
      title.downcase.gsub(/\s+/, '_')
    end

    def get_filename(url)
      if @youtube
        system %Q{youtube-dl --get-filename "#{url}"}
      else
        File.basename(URI.parse(url).path).gsub(/\s+/, '_').gsub('%20', '_')
      end
    end
  end
end
