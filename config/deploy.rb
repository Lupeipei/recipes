require 'dotenv'
Dotenv.load
# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"
sh "ssh-add"
set :application, "recipes"
set :repo_url, "https://github.com/Lupeipei/recipes"

set :deploy_to, "/home/deploy"

set :log_level, :info

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('.env', 'Procfile', 'config/unicorn.rb')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle')

set :bundle_jobs, 4

set :conditionally_migrate, true # Defaults to false. If true, it's skip migration if files in db/migrate not modified

task :deploy => [:production]

namespace :deploy do
  after 'check:make_linked_dirs', :migrate_to_cap do
    on roles(:all) do
      # Try to migrate from the manual installation to capistrano directory structure
      next if test('[ -L ~/recipes ]')
      fetch(:linked_files).each do |f|
        if !test("[ -f ~/shared/#{f} ] ") && test("[ -f ~/recipes/#{f} ]")
          execute("cp ~/recipes/#{f} ~/shared/#{f}")
        end
      end
      execute('mv ~/recipes ~/recipes.manual')
      execute('ln -s ~/current ~/recipes')
    end
  end
  after :publishing, :restart do
    on roles(:all) do
      within release_path do
        execute :rake, 'production:restart'
      end
    end
  end
end
