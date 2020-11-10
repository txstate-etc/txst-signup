source 'https://rubygems.org'

ruby '2.2.4'
# rical library for generating ics files
gem 'ri_cal', :github => 'txstate-etc/ri_cal', :ref => '5891733ef1'

group :development do
  gem 'better_errors'
  gem 'quiet_assets'
  
  # Shows stacktraces with amount of time spent in each function
  # add ?pp=flamegraph to display
  gem 'stackprof', '~> 0.2.7'
  gem 'flamegraph', '~> 0.0.5'
end

gem 'hashie', '3.4.3'

gem 'passenger', '6.0.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'


# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end


gem 'omniauth-cas', github: 'txstate-etc/omniauth-cas', ref: 'c2c538c371'
gem 'exception_notification'
gem 'whenever', require: false
gem 'daemons', require: false
gem 'delayed_job'
gem 'delayed_job_active_record'
group :development do
  gem 'thin'
  gem 'capistrano-passenger', require: false
  gem 'rvm1-capistrano3', require: false
end

# group :deploy do
#   gem 'passenger', require: false
# end

#gem 'signup', github: 'txstate-etc/signup'

# generate static pages
gem 'high_voltage', '~> 2.2.1'

# used by HtmlToPlainText
gem 'htmlentities', '~> 4.3.2'

gem 'simple_form', '3.2.1'

# add cache of association counts
# more flexibly than the builtin version
gem 'counter_culture', '~> 0.1.25'

# convert urls in descriptions into links
# Won't need this after implementing wysiwyg editor.
gem 'rails_autolink', '~> 1.1.6'

#Tags
gem 'acts-as-taggable-on', '3.4.4'

# Attachments/Documents
gem 'paperclip', '~> 4.3.5'

# Nested form helpers (for attachments, instructors, etc)
gem 'cocoon', '~> 1.2.6'

# LDAP user lookups
gem 'net-ldap', '~> 0.9.0'

# Autocomplete for instructors, etc.
# despite the name, works fine on rails 4
gem 'rails-jquery-autocomplete', '~> 1.0.3'

# render pdf documents from ruby code
gem 'prawn', '~> 1.3.0'

# audit model changes
 gem 'paper_trail', '~> 4.1.0'