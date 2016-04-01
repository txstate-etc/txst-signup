namespace :signup do
  task :deploy do
    abort "Don't run in production!" if fetch(:rails_env) == :production

    before 'bundler:install', 'signup:update_revision'
    invoke 'deploy'
  end

  desc "bump remote revision of dev version of signup gem without having to redeploy"
  task :update do
    invoke "signup:update_revision"
    invoke "bundler:install"
    invoke "deploy:restart"
    invoke "delayed_job:restart"
    invoke "static:generate"
  end

  task :update_revision do
    abort "Don't run in production!" if fetch(:rails_env) == :production

    on release_roles :all do
      within release_path do
        newrev = `git ls-remote git://github.com/txstate-etc/signup.git master | awk '{ print $1 }'`.strip

        lockfile = "Gemfile.lock"
        oldrev = gem_revision('signup', capture(:cat, lockfile))

        puts "newrev = |#{newrev}|"
        puts "oldrev = |#{oldrev}|"
        if oldrev != newrev
          puts "rev changed"
          execute :ruby, '-pi', '-e', %{"gsub('#{oldrev}', '#{newrev}')"}, lockfile
        end
      end
    end
  end
end

def gem_revision(name, lockfile)
  lockfile = Bundler::LockfileParser.new(lockfile)
  if spec = lockfile.specs.find { |s| s.name == name }
    spec.source.revision
  end
end

