module Rpodder
  class Update < Base
    def initialize
      super
      look_for_episodes!
    end

    def look_for_episodes!
      podcast   = Podcast.all(:fields => [:rssurl])
      new_feeds = podcast.map { |pcast| pcast.rssurl.to_s }.compact

      Feedzirra::Feed.add_common_feed_entry_element('enclosure',
                                                    :value => :url,
                                                    :as => :enclosure_url)
      Feedzirra::Feed.fetch_and_parse(new_feeds,
        :on_success => lambda { |url, feed| add_episodes(url, feed) },
        :on_failure => lambda { |url, response_code, response_header, response_body| puts response_code })
    end

    private

    def add_episodes(url, feed)
      podcast_id = Podcast.first(:fields => [:id], :rssurl => url.downcase).id
      feed.sanitize_entries!
      count = feed.entries.count
      @conf['episodes'] = count if count < @conf['episodes']
      (0..@conf['episodes']).each do |num|
        episode = feed.entries[num]
        puts "Adding #{episode.title} for #{podcast_id}"
        enclosure_url = (episode.enclosure_url.nil? && episode.url) || episode.enclosure_url
        ep = Episode.first_or_create(
          title:          episode.title,
          url:            episode.url.downcase,
          enclosure_url:  enclosure_url.downcase,
          pub_date:       episode.published,
          podcast_id:     podcast_id
        )

        ep.save
        ep.errors.each do |key, value|
          next if key.include?('taken')
          puts "#{key} #{value}"
        end
      end
    end

  end
end
