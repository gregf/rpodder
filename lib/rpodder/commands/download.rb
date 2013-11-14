module Rpodder
  class Download < Configurator
    def initialize
      super
      look_for_episodes
    end

    def download(episode, youtube)
      url         = episode.enclosure_url
      file        = file_name(url, youtube)
      pcast_title = episode.podcast.title
      begin
        @conf['fetcher'] = 'youtube' if youtube
        fetch_file url, file, pcast_title
      rescue => e
        puts "Failed to download #{url}"
        File.delete(File.join(@conf['download'], file)) if File.exists?(File.join(@conf['download'], file))
      else
        episode.mark_as_downloaded
      end
    end

    def look_for_episodes
      episodes = Episode.all(:downloaded => false, :podcast => {:paused => false})
      episodes.each do |ep|
        youtube = (ep.url.to_s.include?('youtube')) || false
        download(ep, youtube)
      end
    end

    private

    def fetch_file(url, file, pcast_title)
      if @conf['fetcher'] == 'youtube'
        dest_dir = File.expand_path(@conf['download'])
      else
        dest_dir = File.join(File.expand_path(@conf['download']), pcast_title)
        Dir.mkdir dest_dir unless Dir.exists? dest_dir
      end
      case @conf['fetcher']
      when /wget/i
        system %Q{wget -c #{url} -O "#{File.join(dest_dir, file)}"}
      when /curl/i
        system %Q{curl -C #{url} -O "#{File.join(dest_dir, file)}"}
      when /youtube/i
        system %Q{youtube-dl --no-playlist --continue --no-part -o "#{dest_dir}/%(uploader)s/%(title)s.%(ext)s" "#{url}"}
      else
        puts "Unknown fetcher, please check your config file"
        exit 1
      end
    end

    def file_name(url, youtube)
      if youtube
        file = system %Q{youtube-dl --get-filename "#{url}"}
      else
        file = File.basename(URI.parse(url).path).gsub(/\s+/, '_').gsub('%20', '_')
      end
    end
  end
end
