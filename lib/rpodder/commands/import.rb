module Rpodder
  class Import < Base
    def initialize(file)
      super
      parse_opml(file)
      import_urls!
    end

    def parse_opml(file)
      @doc = Nokogiri::HTML(open(file))
    end

    def import_urls!
      @doc.search('outline').each do |item|
        open(@urls_file, 'a') do |f|
          f.puts item['xmlurl']
        end
      end
    end
  end
end
