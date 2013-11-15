module Rpodder
  class Update < Configurator
    def initialize
      super
      look_for_episodes!
    end

    def look_for_episodes!
      podcast = Podcast.all
      podcast.each do |pcast|
        feed = parse_feed(pcast.rssurl.to_s)
        feed.entries.each { |entry| add_episodes(pcast.id, entry) }
      end
    end

    private

    def add_episodes(podcast_id, episode)
      guid = (episode.respond_to?('guid') && episode.guid) || episode.url.to_s + episode.published.to_s
      enclosure_url = (episode.respond_to?('enclosure_url') && episode.enclosure_url) || episode.url
      ep = Episode.first_or_create(
        guid:           guid,
        title:          episode.title.sanitize,
        url:            episode.url,
        enclosure_url:  enclosure_url,
        pub_date:       episode.published,
        podcast_id:     podcast_id
      )

      ep.save
      ep.errors.each do |key, value|
        next if key.include?('taken')
        puts "#{key} #{value}"
      end
    end

    def parse_feed(url)
      Feedzirra::Feed.add_common_feed_entry_element('enclosure',
                                                    :value => :url,
                                                    :as => :enclosure_url)
      Feedzirra::Feed.fetch_and_parse(url)
    end
  end
end
