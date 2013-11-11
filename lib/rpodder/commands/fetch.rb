module Rpodder
  class Fetch < Configurator
    def initialize
      super
      download
    end

    def download
      look_for_episodes
    end

    def download_episode(title, url, guid)
      return if already_downloaded(url, guid)
      title = File.join(File.expand_path(@conf['download']), title)
      file = File.join(title, file_name(url))
      Dir.mkdir title unless Dir.exists? title
      begin
        system "#{@conf['fetcher']} #{url} -O \"#{file}\""
      rescue
        puts "Failed to download #{url}"
        File.delete(file) if File.exists?(file)
      else
        record_download(url, guid) if File.exists?(file)
      end
    end

    def download_yt(title, url, guid)
      return if already_downloaded(url, guid)
      file = yt_filename(url)
      download_path = File.expand_path @conf['download']
      begin
        system %Q{youtube-dl --no-playlist --continue --no-part -o "#{download_path}/%(uploader)s/%(title)s.%(ext)s" "#{url}"}
      rescue
        puts "Failed to download #{url}"
        File.delete(file) if File.exists?(file)
      else
        record_download(url, guid) if File.exists?(file)
      end
    end

    def look_for_episodes
      @urls.each do |url|
        feed ||= parse_urls(url)
        feed.entries.reverse.each do |entry|
          if entry.url =~ /youtube/
            download_yt(feed.title.sanitize!, entry.url, entry.id)
          else
            download_episode(feed.title.sanitize!, entry.enclosure_url, entry.id)
          end
        end
      end
    end

    private

    def parse_urls(url)
      Feedzirra::Feed.add_common_feed_entry_element('enclosure', :value => :url, 
                                                    :as => :enclosure_url)
      Feedzirra::Feed.fetch_and_parse(url)
    end

    def file_name(url)
      File.basename(URI.parse(url).path).gsub(/\s+/, '_').gsub('%20', '_')
    end

    def record_download(url, guid)
      items = @db[:items]
      items.insert(:url => url.downcase, :guid => guid.downcase, :date => Date.today)
    end

    def already_downloaded(url, guid)
      items = @db[:items]
      results = items.where(:url => url.downcase, :guid => guid.downcase)
      if results.count > 0
        true
      else
        false
      end
    end

    def yt_filename(url)
      system %Q{youtube-dl --get-filename "#{url}"}
    end
  end
end
