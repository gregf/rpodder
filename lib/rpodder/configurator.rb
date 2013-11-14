module Rpodder
  class Configurator
    include Rpodder

    def initialize
      @@default_path = get_config_dir
      @@cachedb = File.join(@@default_path, 'cache.db')
      @@urls_file = File.join(@@default_path, 'urls')
      @@config_file = File.join(@@default_path, 'config')
      @@lock_file = File.join(@@default_path, 'rpodder.lock')

      load_working_dir!
      load_config!
      load_urls!
      load_download_dir!
      load_database!
      import_podcasts!
    end

    def load_config!
      unless File.exists?(@@config_file)
        open(@@config_file, 'w') do |f|
          f.puts '[main]'
          f.puts 'download = ~/podcasts'
          f.puts 'fetcher = wget -c'
        end
      end
      @conf ||= IniParse.parse(File.read(@@config_file))['main']
    end

    def load_urls!
      unless File.exists?(@@urls_file)
        open(URLS, 'w') do |f|
          f.puts 'http://foodfight.libsyn.com/rss'
          f.puts 'http://feeds.feedburner.com/BsdNowHd'
          f.puts 'http://www.badvoltage.org/feed/mp3/'
        end
      end
      @urls ||= IO.read(@@urls_file).split.reject { |l| l.strip[0] == '#' }
    end

    private

    def load_database!
      #DataMapper::Logger.new($stdout, :debug)
      DataMapper.setup(:default, "sqlite://#{@@cachedb}")
      DataMapper.finalize
      DataMapper.auto_upgrade!
    end

    def load_working_dir!
      create_dir @@default_path
    end

    def load_download_dir!
      create_dir File.expand_path(@conf['download'])
    end

    def start_logging
      # needs code
    end

    def get_config_dir
      if ENV['XDG_CONFIG_HOME']
        File.join(ENV['XDG_CONFIG_HOME'], 'rpodder')
      else
        File.join(ENV['HOME'], '.rpodder')
      end
    end

    def import_podcasts!
      @urls.each do |url|
        feed = Feedzirra::Feed.fetch_and_parse(url)
        begin
          Curl::Easy.http_get(url)
        rescue => e
          puts "Recieved an error #{e} while accessing #{url}"
          next
        end

        podcast = Podcast.first_or_create(
            title:              feed.title,
            url:                feed.url,
            rssurl:             feed.feed_url
        )

        podcast.save
        podcast.errors.each do |key, value|
          next if key.include?('taken')
          puts "#{key} #{value}"
        end
      end
    end
  end
end
