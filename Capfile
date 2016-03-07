# Monkey patch DSL to set default roles on servers
module Capistrano
  module DSL
    def server(name, properties={})
      properties[:roles] = %w{web app db} unless properties.key? :roles
      super(name, properties)
    end
  end
end
# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
# require 'capistrano/rails/migrations'
require 'capistrano/passenger'
require 'rvm1/capistrano3'
require 'whenever/capistrano'
require 'signup/capistrano'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
