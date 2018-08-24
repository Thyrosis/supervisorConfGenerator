# supervisorConfGenerator
Configuration generator for Laravel queues to be run by SuperVisor on a DirectAdmin controlled CentOS7 server.

# What does it do?

Reads the specified file for a collection of usernames and domains to be added to the Supervisor configuration file.

# What does it need?

The laravelqueues file should reside in the same directory as this script and should be formatted like so:

- username domainname
- username2 domainname2

Configurations are saved in individual files in the supervisord.d/$user files and included in the main /etc/supervisor.conf file by the [include] section at the bottom.
