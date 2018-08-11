#!/bin/bash

######################################################################################################################
#
#       Laravel / SuperVisor conf generator
#
#       Reads the specified file for a collection of usernames and domains to be added to the
#       Supervisor configuration file.
#
#       The laravelqueues file should reside in the same directory as this script
#       and should be formatted like so:
#
#       username domainname
#       username2 domainname2
#
#       Configurations are saved in individual files in the supervisord.d/$user files
#       and included in the main /etc/supervisor.conf file by the [include] section at the bottom..
#
#       @author         Maarten Sax
#       @version        2018-08-10
#
######################################################################################################################

filename=laravelqueues

while read application; do
        user=`echo $application | awk '{print $1}'`
        domain=`echo $application | awk '{print $2}'`

        echo "Adding user $user with domain $domain to Supervisor config"

        touch /home/$user/domains/$domain/storage/logs/worker.log
        chown $user:$user /home/$user/domains/$domain/storage/logs/worker.log

echo '
[program:laravel-worker-'"${user}"']
process_name=%(program_name)s_%(process_num)02d
command=php /home/'"${user}"'/domains/'"${domain}"'/artisan queue:work --sleep=3 --tries=3
autostart=true
autorestart=true
user='"${user}"'
numprocs=2
redirect_stderr=true
stdout_logfile=/home/'"${user}"'/domains/'"${domain}"'/storage/logs/worker.log' > /etc/supervisord.d/$user.ini

done < $filename

echo "Stopping Supervisor to rebuild configs"
supervisorctl stop all
supervisorctl reread
supervisorctl update

echo "Starting Supervisor and calling status"
supervisorctl start all

sleep 3

supervisorctl status
