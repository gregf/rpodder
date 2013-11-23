module Rpodder
  class Update < Base
    def initialize
      super
      look_for_episodes!
    end

    def look_for_episodes!
      podcast   = Podcast.rssurls
      new_feeds = podcast.map { |pcast| pcast.rssurl.to_s }.compact

      Feedzirra::Feed.add_common_feed_entry_element('enclosure',
                                                    :value => :url,
                                                    :as => :enclosure_url)
      Feedzirra::Feed.fetch_and_parse(new_feeds,
        :on_success => lambda { |url, feed| add_episodes(url, feed) },
        :on_failure => lambda { |url, response_code, response_header, response_body| error "#{response_code} - #{url}" })
    end

    private

    def add_episodes(url, feed)
      podcast_id = Podcast.first(:fields => [:id], :rssurl => url).id
      feed.sanitize_entries!
      feeds = feed.entries.first(@conf['episodes'])
      feeds.each do |episode|
        say "Adding #{episode.title} for #{podcast_id}"
        #enclosure_url = (episode.enclosure_url.nil? && episode.url) || episode.enclosure_url
        ep = Episode.first_or_create(
          title:          episode.title,
          url:            episode.url,
          enclosure_url:  episode.enclosure_url,
          pub_date:       episode.published,
          podcast_id:     podcast_id
        )

        ep.save
        ep.errors.each do |key, value|
          next if key.include?('taken')
          error "#{key} #{value}"
        end
      end
    end

  end
end
