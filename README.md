# [Amplify](https://amplifyapp.ca) (WebAPI)

[![CircleCI](https://circleci.com/gh/wcoombs/Amplify-Web.svg?style=shield&circle-token=030f03a14524c5530c203dc2c5f8b0d733389c2f)](https://circleci.com/gh/wcoombs/Amplify-Web)

## Running Amplify Web in a local development environment

#### First run checklist: *(Tailored to Mac users)*
- Clone the repo `git clone git@github.com:wcoombs/Amplify-Web.git`
- install the approriate ruby version (`2.5.0`) also listed in `.ruby-version` file at the root of the project
  - You can use any ruby version manager of your choosing, we've been using [RVM](https://rvm.io/rvm/install) for local development and I choose to use `RBENV` for the production server (play nicely with capistrano)
  - If you use `RVM` installing ruby 2.5.0 is as simple as `rvm install 2.5.0` and the `rvm use 2.5.0` to set that version.
  - Word of caution when use ruby version managers is that some shells behave in unexpected ways when switching between folders and may unset the current version of ruby being used.  I won't get into further details here about managing that.
- install `gem install bundle` bundler will manage our projects gem dependencies
- `npm install` to install yarn (only use npm to install yarn, then use yarn going forward)
- `yarn install` to install our javascript dependencies
- `brew install postgresql` to install postgres
- `brew services list` and confirm that *postgresql* is `started`
- `bundle exec rake db:create` to create our database
- `bundle exec rake db:migrate` to run any outstanding migrations
- create a local secrets file `config/secrets.yml`, we have an [example secrets file](https://github.com/wcoombs/Amplify-Web/blob/master/config/secrets.example.yml) that can be used as a template, to create your development copy.
  - Use `rake secret` if you want to generate your own `secret_key_base` for your local secrets file
- create a local database file `config/database.yml`, we have an [example database file](https://github.com/wcoombs/Amplify-Web/blob/master/config/database.example.yml) that can be used as a template to create your own copy.

#### After pulling the latest from master always:
- `bundle` to fetch any gems that may have been added to the project
- `bundle exec rake db:migrate` to run any new migrations
- `yarn install` to fetch any new javascript dependencies

#### Running the rails server
There are two options for running the rails server
- Simply `rails s` short for `rails server`

Or if you want to run webpacker separately (faster for asset compilation, and css hot reloading)

- `webpack-dev-server` to start the webpack development server
- after the webpack dev server is up `rails s`

> \* A quick fix for database errors related to junk data `bundle exec rake db:reset RAILS_ENV=environment` where `environment` is test/development/staging (never production), `db:reset` will drop the database, then run `create`, `schema:load`, and finally `seed` so it's lazy command to run if you do not care whatsoever about the information in the database.

> \* If you get errors back on the web side asking to update your local database, run the command ```bin/rails db:migrate RAILS_ENV=development```. There should be some tables created if they were missing. Restart the server after the migration is complete.

> \* If you encounter any errors mentioning webpacker, packs, manifest, or any thing javascripty
> - Be sure to run `yarn install` in the project directory to install any javascript dependencies.
> - If `yarn install` fails make sure you have npm installed and up to date, and then do `npm install` in the project directory.

> \* If you continue to have trouble getting the project to run and are evaluating us for grading purposes, email rob @ robert.laurin89@gmail.com

## How to Demo the App Locally
* For ease of use, use your Mac!

1. Create a room
* Set up the local server (must be on a Mac)
* Start the mobile simulator (click the run icon)
* Go into the Amplify-Web repository and run "rails s" to start the server
* Hit "Create Room" button to be given a room code (remember this!)

2. Join a room
* Go to localhost:3000 to access the web app
* Enter the aforementioned room code and a nickname to enter the room (case insensitive)
* View the songs and vote accordingly (you get one vote per song; vote can be changed)

## How to Demo the App on Production
1. Follow the steps under the Mobile repository
2. The link to the production web site is ```https://amplifyapp.ca```

## How to Run the Tests Locally
1. Navigate to the root directory for the repository
2. Run the command ```rspec```
  * If this fails for whatever reason, explicitly state what you want to do (```bundle exec rspec spec```)
3. ...
4. Profit

## Display the Endpoints
1. Navigate to the root directory for the repository
2. Run the command ```rails routes```
3. ...
4. Profit

### API Endpoint Reference

##### Registration
|  Completed  |  Method  |  Endpoint  |  Usage  |  Permission  |  Returns  |
|:-----------:|:--------:|:----------:|:-------:|:------------:|:---------:|
|     ✓     |  POST | /api/register/`room_id` | Join a room | Anybody | - |

##### Rooms
|  Completed  |  Method  |  Endpoint  |  Usage  |  Permission  |  Returns  |
|:-----------:|:--------:|:----------:|:-------:|:------------:|:---------:|
|     ✓     | POST | /rooms/ | Create a room | Anybody | - |
|     ✓     | DELETE | /rooms/`room_id` | Destroy a room | Anybody | - |

##### Playlists
|  Completed  |  Method  |  Endpoint  |  Usage  |  Permission  |  Returns  |
|:-----------:|:--------:|:----------:|:-------:|:------------:|:---------:|
|     ✓     | GET | /api/playlist/`room_id` | View playlist | Authenticated | Songs |
|     ✓     | PUT | /api/playlist/`room_id`/`song_id` | Vote on a song | Authenticated | Song |


# How to setup a production environment
### Creating a new EC2 instance
  - Ubuntu Server 16.04
  - Free tier box
  - Add security group
    - http
    - https
    - ssh
  - Launch!


### Configuring access. [More Info](http://capistranorb.com/documentation/getting-started/authentication-and-authorisation/)
  - create a deployment user
    - `adduser deploy`
    - `passwd -l deploy`
    - add your pub key so you can log in as the deployment user
      - `su - deploy` # this is logging in as the deploy user
      - `cd ~`
      - `mkdir .ssh`
      - `echo "ssh pub key here" >> .ssh/authorized_keys
      - `chmod 700 .ssh`
      - `chmod 600 .ssh/authorized_keys`
      - from your local machine test to see if it worked
        - `ssh deploy@server-ip-here 'hostname; uptime'`

  - give the deploy user access to the repo
     - locally and within the project repo
      - get the git repo url
        - `git config remote.origin.url`
      - `ssh-add`
      - `ssh -A deploy@server-ip-here 'git ls-remote git-url-here'`


### Project dependencies. [More Info](https://coderwall.com/p/ttrhow/deploying-rails-app-using-nginx-puma-and-capistrano-3)
  - install nginx
    - `sudo apt-get update`
    - `sudo apt-get install curl git-core nginx -y`
  - visiting the instance ip now should greet you with an nginx welcome message

  - install ruby and its dependencies [More Info](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04)
    - `sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev`

  - install rbenv for managing our ruby version [More Info](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04)
    - these steps performed as deploy user
    - `git clone https://github.com/rbenv/rbenv.git ~/.rbenv`
    - `echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc`
    - `echo 'eval "$(rbenv init -)"' >> ~/.bashrc`
    - `source ~/.bashrc`
  - type rbenv and it should output some text indicating it's there.
  - get the rbenv install command
    - `git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build`
  - install your project version of ruby
    - `rbenv install 2.5.0 --verbose` # verbose because it seems like it's hanging otherwise :/
    - `rbenv global 2.5.0` # set 2.5.0 as the version to use
    - `gem install bundle` # needed for deployment

  - install postgres [More Info](https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-ubuntu-14-04)
    - `sudo apt-get update`
    - `sudo apt-get install postgresql postgresql-contrib libpq-dev`
    - create postgres user
      - `sudo -u postgres createuser -s pguser` # where pguser is the user name of your choice
      - `sudo -u postgres psql`
      - `\password pguser` # this password needs to be added to the database.yml file
      - `\q` to quit pg

### Add configuration files to the server
  - in /home/deploy/apps/amplify/shared/config
    - create/add a secrets.yml file
    - create/add a database.yml file

### Initial deploy
  - `cap stage deploy` # will probably fail due to db not being created
  - need a better way of doing this but just jump in a recently created release and do
    - `bundle exec rake db:create RAILS_ENV=stage`
  - `cap stage deploy` # should succeed, now we just need to do a final tweak to the nginx conf
  - `sudo rm /etc/nginx/sites-enabled/default`
  - `sudo ln -nfs /home/deploy/apps/amplify/current/config/nginx.conf /etc/nginx/sites-enabled/amplify`
  - `sudo service nginx restart`
