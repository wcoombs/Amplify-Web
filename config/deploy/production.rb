set :rails_env, "production"
set :puma_env, "production"
set :stage, :production
server '34.215.47.251', port: 22, roles: [:web, :app, :db]
