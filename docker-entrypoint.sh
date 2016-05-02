#!/bin/bash

chown -R www-data:www-data /srv/moodledata
chown -R www-data:www-data /srv/moodledata/*

service postfix restart
service rsyslog restart

exec "$@"
