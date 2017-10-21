#!/bin/bash
rm -R /tmp/pids
bundle install
rake db:create
rails s -p 3000 -b 0.0.0.0