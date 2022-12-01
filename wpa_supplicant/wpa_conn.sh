#!/bin/bash
# wpa_conn.sh - 2022-11-30 WD5M
# This wpa_conn.sh script is used as the wpa_cli (-a) action file. 
# Example: wpa_cli -B -a wpa_conn.sh 
# I use /etc/rc.local to start wpa_cli at boot time. 
#
#    /usr/bin/wpa_cli -B -a /root/wpa_conn.sh &>/dev/null
#
# This script may also execute with wpa_cli commands such as
# reassociate or select_network.
#
# From wpa_cli manpage
#
# -B Run as a daemon in the background.
#
# -a file
#    Run in daemon mode executing the action file based on events from wpa_suppli-
#    cant.   The  specified  file  will be executed with the first argument set to
#    interface name and second to "CONNECTED" or "DISCONNECTED" depending  on  the
#    event.   This  can  be used to execute networking tools required to configure
#    the interface.
# 
#    Additionally, three  environmental  variables  are  available  to  the  file:
#    WPA_CTRL_DIR, WPA_ID, and WPA_ID_STR. WPA_CTRL_DIR contains the absolute path
#    to the ctrl_interface socket. WPA_ID contains the unique  network_id  identi-
#    fier  assigned  to the active network, and WPA_ID_STR contains the content of
#    the id_str option.
#
case "$2" in
	CONNECTED)
		# run a script to kill and restart the openvpn VPN client connection
		echo "${1} ${2} running restart-openvpn"
		/etc/openvpn/restart-openvpn
	;;
	DISCONNECTED)
		echo "${1} ${2}"
	;;
	*)
		echo "${1} ${2} unrecognized argument"
	;;
esac
exit 0
