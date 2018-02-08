set :rails_env, "staging"
set :puma_env, "staging"
set :stage, :staging
set :staging_ip,  ENV['STAGING_IP'] || "34.217.80.89"
server "#{fetch(:staging_ip)}", port: 22, roles: [:web, :app, :db]
