# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.autoload_paths << "#{RAILS_ROOT}/app/reports"

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "ri_cal", :version => '0.8.7'
  config.gem "net-ldap", :version => '0.1.1'
  config.gem "fastercsv", :version => '1.5.3'
  config.gem "searchlogic", :version => '2.4.27'
  config.gem "pdf-reader", :lib => "pdf/reader"
  config.gem "Ascii85", :lib => "ascii85"
  config.gem "prawn", :version => '0.11.1'
  config.gem "calendar_date_select", :version => '1.16.2'
  config.gem "repeated_auto_complete"
  config.gem "delayed_job", :version => '~>2.0.4'
  config.gem "whenever"
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Central Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://llavero.its.txstate.edu/cas"
)

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(:default => "%A %m/%d/%Y")
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:default => "%l:%M%p %A, %B %e, %Y")

CalendarDateSelect::FORMATS[:my_custom] = {
# Here's the code to pass to Date#strftime
  :date => "%B %e, %Y",
  :time => " %l:%M %p",  # notice the space before time.  If you want date and time to be seperated with a space, put the leading space here.

  :javascript_include => "format_my_custom"
}
CalendarDateSelect.format = :my_custom

# Change error display to use a SPAN instead of a DIV
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| "<span class=\"fieldWithErrors\">#{html_tag}</span>" }