set :application, 'timesheet'
set :repo_url, 'git@github.com:NilsLattek/Timesheet.git'
set :branch, "master"

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/timesheet'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Symlinks the database.yml'
  task :symlink_db do
    on roles(:app) do
      execute :ln, '-nfs', "#{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
  end

  desc "Symlinks the timesheet print template"
  task :symlink_print_template do
    on roles(:app) do
      execute :ln, '-nfs', "#{shared_path}/templates/index.print.erb #{release_path}/app/views/timesheets/index.print.erb"
    end
  end

  desc "Symlinks the company logo"
  task :symlink_logo do
    on roles(:app) do
      execute :ln, '-nfs', "#{shared_path}/templates/logo.png #{release_path}/app/assets/images/logo.png"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

  before :compile_assets, 'deploy:symlink_db', 'deploy:symlink_print_template', 'deploy:symlink_logo'

end
