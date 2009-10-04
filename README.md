# Nanite / Rails Test App

This application was created to debug rails, nanite, nanite-plugin, rufus-scheduler and passenger.

## Install and Run

 - git clone this repo
 - setup rabbitmq if necessary (see http://github.com/ezmobius/nanite)
 - make sure you setup rabbitmq permissions (can try running `rake nanite:rabbitmq` as root)
 - run the rails app.  I use passenger, so I setup a new vhost like this:
   <pre><code>
     <VirtualHost *:80>
       ServerName goo.local
       DocumentRoot /Users/farra/dev/goo/public
     </VirtualHost>
   </code></pre>
 - run the counter nanite agent:

    ./script/nanite -a counter start

 - visit the website at http://goo.local (or http://localhost:3000 if you use that)

## What?

It's a simple rails app with a single controller and a single model.
The Count model just keeps a totel.  The counts controller:

  - shows the current count (the first Count model)
  - allows you to manual increment the count
  - allows you to send a Nanite request to increment the count
  - allows you to schedule a repeating background job to increment the count

There is a single nanite actor:

  - /counters/increment :: sends an HTTP POST to the increment path
  - /counters/schedule :: schedules a repeating job to send an HTTP POST to the _async_ increment path

The scheduler is a bit convoluted, mostly to properly exercise the
whole chain of events.  When you press the schedule button, the
following happens:

  - the rails app processes the HTTP POST and sends a Nanite request to /counters/schedule
  - the schedule agent creates a rufus-scheduler job to repeatedly send an HTTP POST request to the _async_ increment path
  - the job triggers, sending the HTTP POST
  - the rails app gets the HTTP POST and in turn sends another Nanite request to the /counters/increment agent
  - the /counters/increment agent sends an HTTP POST to the rails increment path
  - the rails app increments the count

## Why?

When run under passenger, this app will occasionally break, giving you
a `RuntimeError (eventmachine not initialized:
evma_send_data_to_connection)` error.  This app is an attempt to debug this behavior.

The error tends to occur on startup.  If you don't get it, try
restarting the app.

See [this thread on the nanite google group][1] for more information.

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


[1] http://groups.google.com/group/nanite/browse_thread/thread/22af18ad9677be57?hl=en


 