# Nanite / Rails Test App

This application was created to debug rails, nanite, nanite-plugin, rufus-scheduler and passenger.

## Install and Run

 - git clone this repo
 - setup rabbitmq if necessary (see http://github.com/ezmobius/nanite)
 - make sure you setup rabbitmq permissions (can try running "rake nanite:rabbitmq" as root)
 - run the rails app.  I use passenger, so I setup a new vhost like this:
    <VirtualHost *:80>
      ServerName goo.local
      DocumentRoot /Users/farra/dev/goo/public
    </VirtualHost>
 - run the counter nanite agent:
    ./script/nanite -a counter start
 - visit the website at http://goo.local (or http://localhost:3000 if you use that)

## How?

This project was developed via the following approximate steps

 - rails goo
 - cd goo
 - script/plugin install git://github.com/dcu/nanite-rails.git
 - ./script/generate nanite
 - ./script/generate agent counter schedule count
 - ./script/generate model Count total:integer interval:integer
 - ./script/generate controller counts
 - rake db:migrate
 - modify environment.rb
 - modify routes.rb
 - setup passenger vhosts
 - edit the counts_counter and the count nanite agent


 