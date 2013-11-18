module Rpodder
  class Base < Configurator
    def initialize
      super
      load_database!
      import_podcasts!
    end

    def load_database!
      #DataMapper::Logger.new($stdout, :debug)
      DataMapper.setup(:default, "sqlite://#{cachedb}")
      DataMapper.finalize
      DataMapper.auto_upgrade!
    end

    def import_podcasts!
      urls.each do |url|
        feed = Feedzirra::Feed.fetch_and_parse(url)
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
