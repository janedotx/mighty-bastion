== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.

To get this app to the point where it can run locally and you can run tests, you'll need to do the following:
* Install Ruby 2.3.1.
* `bundle install`
* Set up development and test Postgres instances. (Unfortunately, rspec-rails makes certain assumptions about your
use of a database that I hadn't anticipated before choosing Rails and rspec. No database is actually written to.)

To set up the databases on OS X, you'll need to:

* Install postgres. Homebrew works.
* Create a database:

    ```
    initdb /usr/local/var/postgres -E utf8
    ```
* Start the postgres daemon.

    ```
    postgres
    ```
    or if that doesn't work:

    ```
    pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
    ```
    * Create a database named tcubed_development, and another named tcubed_test.

    ```
    $ psql postgres

    postgres> create database tcubed_development;
    ```
    If ```psql``` fails, you may need to ```sudo ln -s /tmp/.s.PGSQL.<NUMBER> /var/pgsql_socket/.s.PGSQL.<NUMBER>``` to get the socket file        working properly.

Then it should be a case of running `bundle exec rspec spec` from the project root.

This is a Rails app that enables a Slack team to play tic tac toe. Games are stored in memory and will not be saved
if the application crashes for some reason.

This is the API. The name of the API route is the same as the name of the slash command in the private Slack team,
except in the case of the `help` endpoint:

## GET display

Prints out the current board of any game that is ongoing.

## POST challenge

Starts a new game by challenging another player.

## GET help

Prints out some help text. On the private Slack team, this command is mapped to to /tcubedhelp.

## POST move

Make a move in the tic tac toe game.

## POST cheat

Enable any player in the channel to cheat, even if they are not in the current game.
