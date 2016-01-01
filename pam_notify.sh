#! /bin/sh

#This script send an email to the root user when a pam session is opened
#Add the followings lines at the end of /etc/pam.d/common-session and /etc/pam.d/sudo :
# session    optional     pam_exec.so /path/to/pam_notify.sh

#Require a mail binary in path

if [ ! "$PAM_TYPE" = "open_session" ]; then
        exit 0
fi

#proxmox related ? every mortning at 6am
if [ "$PAM_RUSER" = "root" ] && [ "$PAM_USER" = "nobody" ] && [ "$PAM_RHOST" = "" ] && [ "$PAM_SERVICE" = "su" ]; then
	exit 0
fi

{
  echo "User: $PAM_USER"
  echo "Ruser: $PAM_RUSER"
  echo "Rhost: $PAM_RHOST"
  echo "Service: $PAM_SERVICE"
  echo "TTY: $PAM_TTY"
  echo "Type : $PAM_TYPE"
  echo "Date: `date`"
  echo "Server: `uname -a`"
} | mail -s "`hostname -s` $PAM_SERVICE login: $PAM_USER" root

exit 0
