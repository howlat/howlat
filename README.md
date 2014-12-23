Howlat - Chat Application
==========================
[![Howlat Room](http://chat.howlat.me/madgloryint/parleychat/badge.png)](http://chat.howlat.me/madgloryint/parleychat)
[![Code Climate](https://codeclimate.com/repos/5333e475e30ba02886001cad/badges/806dd8dae812e4808df0/gpa.png)](https://codeclimate.com/repos/5333e475e30ba02886001cad/feed)
# Overview

The Chat Application provides the following high level functionality:

  * Create & manage organizations, users, rooms
  * Room user interface

The Chat Application encompasses two components; a client-side application, and a hosted middle-tier application.  A Chat Server exists as well; we currently use a fairly stock version of eJavverd. The Chat Application consists of two components, a traditional hosted application that display a web portal, and a client-side application that presents a rich chat interface to the user.  Both components interact as needed with the Chat Server, which facilitates realtime communication between client and server.

NOTE: The distinction between hosted application and chat server was made early on in order to separate the "realtime" portion of the application from the traditional request/response portion of the application.

The Chat Application has been designed with the following criteria:

  * Facilitate all administrative functions required to manage chat rooms.
  * Provide an interface for linking third-party services (Github, Trello, etc.)
  * Render all user interface components

  Note: By design, when users are actually chatting, very little (and ideally zero) communication is required with the hosted portion of the application.  Instead, the client portion of the application should communicate directly with the chat server.


## Technology
The hosted application is written in Ruby on Rails (version 4.x) and the client application is written in AngularJS.  This stack was chosen due to our ability to rapidly iterate on features, and our interest in working with these technologies.

## Prerequisites

  * Ruby 2.0
  * Redis
  * Postgres

## Authentication

The application will provide for authencitation via Github, and via traditional username & password.

## Authorization

The application will provide an internal authorization system.  Users will be members of one or more organizations, users may be granted access to rooms within the organization.

## Transport

We will use HTTP, and will require SSL in production. We will support GZIP compression for all protocol responses, provided by NodeJS.

## Development

Ensure all dependencies are installed and running.

Setup database dependencies & start the application:

    $ cp config/database.yml.sample config/database.yml
    $ bin/rake db:setup
    $ bin/rails start

NOTE: You may be required to edit the database.yml file to provide an alternative username.  On OSX using homebrew, the postgres username is the username of the account that installed Postgress.

We've included an Editor Config (http://editorconfig.org/) file.  Please use it.

## Testing

To run the tests:

    bin/rake

## Staging

We're currently hosting on heroku.  The app is here: http://chat.howlat.me
