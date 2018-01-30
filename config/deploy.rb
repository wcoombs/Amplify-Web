# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"

# Project Specific
set :application, "amplify"
set :user, 'deploy'
set :repo_url, "git@github.com:wcoombs/Amplify-Web.git"
set :tmp_dir, "/home/deploy/tmp"

set :rbenv_ruby, '2.5.0'
set :rbenv_type, :user
# set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
# set :rbenv_map_bins, %w{rake gem bundle ruby rails}
# set :rbenv_roles, :all # default value

# Standards
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }

# Default branch is :master
set :branch, ENV['CAP_BRANCH'] || :master # eg: CAP_BRANCH=custom-branch cap sandbox deploy (or for fish: begin; set -lx CAP_BRANCH cusomt-branch; cap sandbox deploy; end)

set :linked_dirs,  fetch(:linked_dirs, []).push('log', 'tmp')


#Don't touch
set :pty,             false
set :use_sudo,        false

set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
