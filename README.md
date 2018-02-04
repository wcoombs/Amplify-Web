# Amplify (WebAPI)

[![CircleCI](https://circleci.com/gh/wcoombs/Amplify-Web.svg?style=shield&circle-token=030f03a14524c5530c203dc2c5f8b0d733389c2f)](https://circleci.com/gh/wcoombs/Amplify-Web)


# How to setup a production environment
### Creating a new EC2 instance
  - Ubuntu Server 16.04
  - Free tier box
  - Add security group
    - http
    - https
    - ssh
  - Launch!


### SSH into the new instance. [More Info](http://capistranorb.com/documentation/getting-started/authentication-and-authorisation/)
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


### Start installing project dependencies. [More Info](https://coderwall.com/p/ttrhow/deploying-rails-app-using-nginx-puma-and-capistrano-3)
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

Setup configuration files
  - in /home/deploy/apps/amplify/shared/config
    - create/add a secrets.yml file
    - create/add a database.yml file

Initial deploy
  - `cap stage deploy` # will probably fail due to db not being created
  - need a better way of doing this but just jump in a recently created release and do
    - `bundle exec rake db:create RAILS_ENV=stage`
  - `cap stage deploy` # should succeed, now we just need to do a final tweak to the nginx conf
  - `sudo rm /etc/nginx/sites-enabled/default`
  - `sudo ln -nfs /home/deploy/apps/amplify/current/config/nginx.conf /etc/nginx/sites-enabled/amplify`
  - `sudo service nginx restart`
