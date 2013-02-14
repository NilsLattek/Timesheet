# Timesheet

A simple timesheet application.

## Setup

1) Copy `config/database.yml.sample` to `config/database.yml`.

2) Install dependencies:

    $ cd Timesheet
    $ bundle install

3) Create database with admin user

    $ bundle exec rake db:setup

4) Start server

    $ bundle exec rails s

5) Navigate to http://localhost:3000 and login with `admin@localhost.com` and password `admin123`