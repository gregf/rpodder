module Rpodder
  class ListPodcasts < Configurator
    def initialize
      super
      get_podcasts
      format_podcasts
    end

    def get_podcasts
      @podcasts ||= Podcast.all
      if @podcasts.count == 0
        puts "No podcasts found"
        exit 1
      end
    end

    def format_podcasts
      rows = []
      @podcasts.each do |pcast|
        rows << [pcast.id, pcast.title, pcast.rssurl]
      end
      table = Terminal::Table.new :headings => ['ID', 'Title', 'Rss url'], :rows => rows
      table.style = {
        :border_x => "-",
        :border_y => " ",
        :border_i => '+'
      }
      puts table
    end
  end
end
