# Change these
set :application, "amplify"
set :user, 'deploy'
set :repo_url, "git@github.com:wcoombs/Amplify-Web.git"
set :tmp_dir, "/home/deploy/tmp"
set :rbenv_ruby, '2.5.0'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false

set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to true if using ActiveRecord

## Defaults:
# set :scm,           :git
set :branch, ENV['CAP_BRANCH'] || "configure-capistrano" # eg: CAP_BRANCH=custom-branch cap sandbox deploy (or for fish: begin; set -lx CAP_BRANCH cusomt-branch; cap sandbox deploy; end)
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml', 'config/database.yml')
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end


# Clearing out existing tasks, so we decide what's needed for asset compilation
Rake::Task["deploy:compile_assets"].clear

namespace :deploy do
  desc 'Compile assets'
  task :compile_assets => [:set_rails_env] do
    invoke 'deploy:assets:precompile_local'
  end

  namespace :assets do
    desc "Precompile assets locally and then rsync to web servers"
    task :precompile_local do
      # compile assets locally
      run_locally do
        execute "RAILS_ENV=#{fetch(:stage)} bundle exec rake assets:precompile"
      end

      local_dir = "./public/packs/"
      on roles(fetch(:assets_roles, [:web])) do
        remote_dir = "#{fetch(:user)}@#{host.hostname}:#{release_path}/public/packs/"
        run_locally { execute "rsync -av --delete #{local_dir} #{remote_dir}" }
      end
      run_locally { execute "rm -rf #{local_dir}" }
    end
  end

  desc 'Make sure local git is in sync with remote.'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
