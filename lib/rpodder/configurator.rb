module Rpodder
  class Configurator
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
      load_cachedb
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
      @urls ||= IO.readlines(@@urls_file).reject { |l| l.strip[0] == '#' }
    end

    private

    def load_working_dir!
      Dir.mkdir @@default_path unless Dir.exists? @@default_path
    end

    def load_download_dir!
      Dir.mkdir(File.expand_path @conf['download']) unless Dir.exists?(File.expand_path @conf['download'])
    end

    def load_cachedb
      @db ||= Sequel.connect("sqlite://#{@@cachedb}")
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
  end
end
