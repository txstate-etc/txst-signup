ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

DEFAULT_SERVER_PORT = 6944

# set default port for dev server
require 'rails/commands/server'
module Rails
  class Server
    def default_options
      super.merge({
        :Port => DEFAULT_SERVER_PORT
      })
    end
  end
end
