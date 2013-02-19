# Timesheet

A simple timesheet application.

Currently in use at [geomobile.de](http://www.geomobile.de)

## Setup

1) Create and configure `database.yml`:

    $ cp config/database.yml.sample config/database.yml

2) Create a print template for the timesheet:

    $ cp app/views/timesheets/index.print.erb.sample app/views/timesheets/index.print.erb

3) Install dependencies:

    $ bundle install

4) Create database with admin user

    $ bundle exec rake db:setup

5) Start server

    $ bundle exec rails s

6) Navigate to [http://localhost:3000](http://localhost:3000) and login with `admin@localhost.com` and password `admin123`


## Deployment

Create deployment configuration:

    $ cp config/deploy/production.rb.sample config/deploy/production.rb

Make sure to place a `database.yml` and `index.print.erb` on your server (`shared/config/`). For details take a look at the capistrano tasks in `config/deploy/production.rb`

Deploy using capistrano

    $ cap deploy

If there are pending migrations use the following deploy task:

    $ cap deploy:migrations