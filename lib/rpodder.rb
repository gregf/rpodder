# encoding: utf-8
require 'docopt'
require 'data_mapper'
require 'feedzirra'
require 'fileutils'
require 'iniparse'
require 'date'

module Rpodder
  require_relative 'rpodder/version.rb'
  require_relative 'rpodder/runner.rb'
  require_relative 'rpodder/configurator'

  require_relative 'rpodder/commands/download'
  require_relative 'rpodder/commands/update'
  require_relative 'rpodder/commands/list_podcasts'
  require_relative 'rpodder/commands/list_episodes'

  require_relative 'rpodder/database/podcast'
  require_relative 'rpodder/database/episode'
end
