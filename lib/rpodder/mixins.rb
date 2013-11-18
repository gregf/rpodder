module Rpodder
  module Mixins
    def create_dir(dirname)
      FileUtils.mkdir_p(dirname) unless Dir.exists?(dirname)
    end

    def create_file(name)
      create_dir(File.dirname(name))
      FileUtils.touch(name) unless File.exists?(name)
    end

    def delete_file(name)
      File.delete(name) rescue nil
    end

    def remove_empty_dirs(dirname)
      Dir.glob("#{dirname}/*") do |dir|
        begin
          Dir.rmdir(dir)
        rescue SystemCallError
          next
        end
      end
    end
  end
end
