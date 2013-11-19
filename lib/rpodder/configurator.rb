module Rpodder
  class Configurator
    include Rpodder::Mixins

    def initialize(*args)
      load_config!
    end

    def load_config!
      create_config_file unless File.exists?(config_file)
      @conf ||= IniParse.parse(File.read(config_file))['main']
    end

    def urls
      create_urls_file unless File.exists?(urls_file)
      urls = []
      IO.read(urls_file).each_line do |line|
        line.chomp! && line.strip!
        next if line[0] == '#'
        urls.push line.downcase
      end
      urls.compact
    end

    def cachedb
      File.join(default_path, 'cache.db')
    end

    def urls_file
      File.join(default_path, 'urls')
    end

    def config_file
      File.join(default_path, 'config')
    end

    def create_config_file
      open(config_file, 'w') do |f|
        f.puts '[main]'
        f.puts 'download = ~/podcasts'
      end
    end

    def create_urls_file
      open(urls_file, 'w') do |f|
        f.puts 'http://foodfight.libsyn.com/rss'
        f.puts 'http://feeds.feedburner.com/BsdNowHd'
        f.puts 'http://www.badvoltage.org/feed/mp3/'
      end
    end

    def load_working_dir!
      create_dir default_path
    end

    def load_download_dir!
      create_dir File.expand_path(@conf['download'])
    end

    def start_logging
      # needs code
    end

    def default_path
      if ENV['XDG_CONFIG_HOME']
        File.join(ENV['XDG_CONFIG_HOME'], 'rpodder')
      else
        File.join(ENV['HOME'], '.rpodder')
      end
    end
  end
end
