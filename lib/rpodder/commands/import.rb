module Rpodder
  class Import < Base
    def initialize(file)
      super
      import_urls!(file)
    end

    def import_urls!(file)
      opml = Nokogiri::HTML(open file)
      opml.search('outline').each do |item|
        open(urls_file, 'a') do |f|
          f.puts item['xmlurl']
        end
      end
    end
  end
end
