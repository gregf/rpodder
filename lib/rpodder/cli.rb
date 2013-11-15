module Rpodder
  class CLI < Thor
      desc "fetch", "Update & Download"
      def fetch
        Rpodder::Update.new
        Rpodder::Download.new
      end
      desc "lscasts" ,"List podcasts"
      def lscasts
        Rpodder::List_podcasts.new
      end
      desc 'lseps', 'List episodes'
      def lseps
        Rpodder::List_episodes.new
      end
      desc 'download', 'Download podcast episodes'
      def download
        Rpodder::Download.new
      end
      desc 'update', 'Fetch a list of new episodes to be downloaded'
      def update
        Rpodder::Update.new
      end
      desc 'import <file|url>', 'Import a opml file'
      def import(file)
        Rpodder::Import.new(file)
      end
      desc 'version', 'Print version'
      def version
        puts "Version: #{Rpodder::VERSION}"
      end
  end
end
