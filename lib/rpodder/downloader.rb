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
      @url                = episode.enclosure_url.to_s
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
          youtube_flags = %W[--no-playlist --continue --no-part -f #{@conf['youtube-quality']} -o #{podcasts_directory}/#{podcast_title}/%(title)s.%(ext)s #{url}]
          system 'youtube-dl', *youtube_flags
        else
          wget_flags = %W[-c #{url} -O #{output}]
          system 'wget', *wget_flags
        end
      rescue => e
        error "Failed to download #{url}"
        puts e
      end
    end

    private

    def format_title(title)
      title.downcase!
      title.gsub!(/\s+/, '-')     # Convert whitespaces to dashes
      title.gsub!(/-\z/, '')      # Remove trailing dashes
      title.gsub!(/-+/, '-')      # get rid of double-dashes
      title
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
