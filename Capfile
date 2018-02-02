# Load DSL and set up stages
require "capistrano/setup"
require "capistrano/deploy"

require 'capistrano/rails'
require "capistrano/bundler"
require "capistrano/rbenv"
require 'capistrano/puma'

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
