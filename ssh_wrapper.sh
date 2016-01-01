#! /bin/sh

#This script is intended to be run as command= directive of ssh authorized_key file in order to deny running every command except vncproxy, allowing a better proxmox cluster isolation
# vncproxy should be authorized in order to allow proxmox remote console to work across the cluster
#I recommend not using default /root/.ssh/authorized_keys for this script because it is symlinked to a file shared between all cluster members, and is therefor easy to modify (allowing to bypass this security)
# Consider using AuthorizedKeysFile in sshd_config in order to use a fully isolated authorized_key file (for example, ~/.ssh/authorized_keys_secured)

#This script require the followings pakages : coreutils (for cut) and grep (for egrep)

#Example of ssh authorized_keys :
#from="proxmox_node_ip",command="/path/to/ssh_wrapper.sh",no-port-forwarding,no-x11-forwarding,no-agent-forwarding,no-user-rc,no-pty <yoursshkey>

#debug
#echo $SSH_ORIGINAL_COMMAND > /tmp/wrapperdebug

first=`echo $SSH_ORIGINAL_COMMAND | cut -f 1 -d " "`
second=`echo $SSH_ORIGINAL_COMMAND | cut -f 2 -d " "`

case "$first $second" in
	"/usr/sbin/qm vncproxy")
		regex="^/usr/sbin/qm vncproxy [0-9]+$"
		#if you wish yo use bash instead of sh, uncomment this
		#if [ "$SSH_ORIGINAL_COMMAND" = "$regex" ]; then
 		#	$SSH_ORIGINAL_COMMAND

		#if you wish to use bash instead of sh, comment out the 2 following lines
		if echo $SSH_ORIGINAL_COMMAND | egrep "$regex" > /dev/null; then
			$SSH_ORIGINAL_COMMAND
		else
			echo "Sorry, regex validation failed for /usr/sbin/qm vncproxy"
		fi
		;;
	*)
		echo "Sorry. Unauthorized command."
		exit 1
		;;
esac
