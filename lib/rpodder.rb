# encoding: utf-8
require 'docopt'
require 'data_mapper'
require 'feedzirra'
require 'fileutils'
require 'iniparse'
require 'date'
require 'terminal-table'

# misc
require_relative 'rpodder/version.rb'
require_relative 'rpodder/runner.rb'
require_relative 'rpodder/configurator'
# commands
require_relative 'rpodder/commands/download'
require_relative 'rpodder/commands/update'
require_relative 'rpodder/commands/list_podcasts'
require_relative 'rpodder/commands/list_episodes'
# database
require_relative 'rpodder/database/podcast'
require_relative 'rpodder/database/episode'

module Rpodder
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
end
