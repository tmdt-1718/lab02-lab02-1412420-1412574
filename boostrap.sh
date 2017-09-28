#!/bin/bash
rm /tmp/pids/server.pid
bundle install
rake db:create
rails s -p 3000 -b 0.0.0.0