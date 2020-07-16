#!/bin/bash

# bash -l -c 'rails s -e production -b 0.0.0.0 -p 3000'
# bash -l -c 'rails s  -b 0.0.0.0 -p 3000'

trap killall SIGINT INT SIGHUP HUP SIGTERM TERM SIGQUIT QUIT

killall() {
	kill $HTTPDPID
	exit
}

#rake db:setup
#rake db:migrate
#bash -l -c 'rake db:setup'
bash -l -c 'rake db:migrate'
bash -l -c 'whenever --update-crontab'

cron

bash -l -c '/usr/sbin/apache2 -DFOREGROUND'&
HTTPDPID=$!

while true; do sleep 1; done
