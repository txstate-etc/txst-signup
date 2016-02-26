# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'txst-signup'
set :repo_url, "https://github.com/txstate-etc/#{fetch(:application)}"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/txst-signup
# set :deploy_to, '/var/www/txst-signup'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


set :user, 'rubyapps'

set :ssh_options, { user: fetch(:user) }

# Set rvm version to the same as we use in development
set :rvm1_ruby_version, "ruby-#{IO.read('Gemfile').match(/^ruby '([^']+)'$/)[1]}@#{IO.read('.ruby-gemset').chomp}"

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

set :passenger_restart_with_touch, true

set :linked_files, %w{config/secrets.yml}
set :linked_dirs, %w{backups log tmp/pids public/system}

before 'deploy', 'rvm1:install:rvm'
before 'deploy', 'rvm1:install:ruby'
before 'deploy', 'rvm_local:alias:create'
after 'deploy:publishing', 'delayed_job:restart'

after 'deploy:finished', 'static:generate'

# Deploy to training after successfully deploying to production
if fetch(:stage) == :production
  after 'deploy:finished', 'deploy_to_training' do
    puts "Deploying to 'training'"
    exec "cap training deploy"
  end
end

