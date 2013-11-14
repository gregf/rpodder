module Rpodder
  class List_episodes < Configurator
    def initialize
      super
      get_episodes
      format_episodes
    end

    # TODO Not very useful should be able to pass the podcast name
    def get_episodes
      @episodes ||= Episode.all
      if @episodes.count == 0
        puts "No episodes found."
        exit 1
      end
    end

    def format_episodes
      @episodes.each do |eps|
        puts "#{eps.id} #{eps.title} - #{eps.url}"
      end
    end

  end
end
