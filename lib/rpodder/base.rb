module Rpodder
  class Base < Configurator
    def initialize(*args)
      super

      load_working_dir!
      load_download_dir!

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
      feeds = Feedzirra::Feed.fetch_and_parse(new_feeds,
      :on_success => lambda { |url, feed| cache_feed(url, feed) },
      :on_failure => lambda { |url, response_code, response_header, response_body| puts response_body })
    end

    protected

    def cache_feed(url, feed)
        puts "Importing #{url}"
        podcast = Podcast.first_or_create(
            title:              feed.title.downcase,
            url:                feed.url.downcase,
            rssurl:             url
        )
        podcast.save
        podcast.errors.each do |key, value|
          next if key.include?('taken')
          puts "#{key} #{value}"
        end
    end

    def new_feeds
      urls - podcasts
    end

    def podcasts
      feeds  = Podcast.all(:fields => [:rssurl])
      Set.new(feeds.map {|pcast| pcast.rssurl.to_s})
    end
  end
end
