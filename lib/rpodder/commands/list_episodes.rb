module Rpodder
  class ListEpisodes < Base
    def initialize
      super
      get_episodes
      format_episodes
    end

    #TODO: Not very useful should be able to pass the podcast name
    def get_episodes
      @episodes ||= Episode.all
      if @episodes.count == 0
        error 'No episodes found.'
        exit 1
      end
    end

    def format_episodes
      @episodes.each do |eps|
        say "#{eps.id} #{eps.title} - #{eps.url}"
      end
    end

  end
end
