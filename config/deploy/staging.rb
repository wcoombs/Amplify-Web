set :rails_env, "staging"
set :puma_env, "staging"
set :stage, :staging
server '34.215.47.251', port: 22, roles: [:web, :app, :db]
