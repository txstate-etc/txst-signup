#!/bin/bash
export RAILS_ENV=${RAILS_ENV:production}
export CAS_URL=${CAS_URL:-http://localhost:2000}
export WEB_HOSTNAME=${WEB_HOSTNAME:-`hostname`}
export SERVER_ADMIN=${SERVER_ADMIN:-}
export SUPPORT_EMAIL=${SUPPORT_EMAIL:-}

export DB_DATABASE=${DB_DATABASE:-signup}
export DB_USER=${DB_USER:-root}
export DB_PASS=${DB_PASS:-}
export DB_HOST=${DB_HOST:-mysql}
export DB_PORT=${DB_PORT:-3306}

perl -i -pe 's/\Q{{RAILS_ENV}}\E/$ENV{RAILS_ENV}/' /etc/apache2/apache2.conf
perl -i -pe 's/\Q{{WEB_HOSTNAME}}\E/$ENV{WEB_HOSTNAME}/' /etc/apache2/apache2.conf
perl -i -pe 's/\Q{{SERVER_ADMIN}}\E/$ENV{SERVER_ADMIN}/' /etc/apache2/apache2.conf
perl -i -pe 's/\Q{{SERVER_ADMIN}}\E/$ENV{SERVER_ADMIN}/' /usr/app/config/application.rb

perl -i -pe 's/\Q{{sslkeyfile}}\E/glob("\/ssl\/*.key.pem")/e' /etc/apache2/apache2.conf
perl -i -pe 's/\Q{{sslcertfile}}\E/glob("\/ssl\/*.cert.pem")/e' /etc/apache2/apache2.conf

exec "$@"
