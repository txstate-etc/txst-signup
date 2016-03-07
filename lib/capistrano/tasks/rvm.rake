namespace :rvm_local do
  namespace :alias do
    desc "Create an alias for the given"
    task :create do
      on roles(fetch(:rvm1_roles, :all)) do
        within fetch(:release_path) do
          execute "#{fetch(:rvm1_auto_script_path)}/rvm-auto.sh",
            fetch(:rvm1_ruby_version), "rvm", "alias", "create",
            fetch(:rvm1_alias_name), fetch(:rvm1_ruby_version)
        end
      end
    end
    before :create, "deploy:updating"
    before :create, 'rvm1:hook'
  end

  # https://github.com/mattbrictson/capistrano-mb/blob/61f2fe9d6416359110e93f9aab91e82faac0543e/lib/capistrano/tasks/bundler.rake
  namespace :bundler do
    desc "Install correct version of bundler based on Gemfile.lock"
    task :gem_install do
      on fetch(:bundle_servers) do
        within release_path do
          if (bundled_with = capture_bundled_with)
            execute "#{fetch(:rvm1_auto_script_path)}/rvm-auto.sh", fetch(:rvm1_ruby_version), 'gem', 'install', 'bundler', '-v', bundled_with
          end
        end
      end
    end
    before 'bundler:install', 'rvm_local:bundler:gem_install'

    def capture_bundled_with
      lockfile = "Gemfile.lock"
      return unless test "[ -f #{release_path.join(lockfile)} ]"

      ruby_expr = 'puts $<.read[/BUNDLED WITH\n   (\S+)$/, 1]'
      version = capture :ruby, "-e", ruby_expr.shellescape, lockfile
      version.strip!
      version.empty? ? nil : version
    end
  end
end
