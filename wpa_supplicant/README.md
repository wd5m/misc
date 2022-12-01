The wpa_supplicant folder contains some scripts I use on my Clearnode version of Hamvoip.

My Raspberry PI wpa_supplicant configuration file, /etc/wpa_supplicant/wpa_supplicant_custom-wlan0.conf, looks something like the following. The WiFI networks are configured for preference using the priority setting. The higher number value means higher priority. As I move my RPI it will  reconnect to the available WiFi connections. And with my wpa_conn.sh script used with wpa_cli, it will auto restart the openvpn VPN connection when a WiFi connection change occurs.

	ctrl_interface=/run/wpa_supplicant
	update_config=1
	bgscan="simple:30:-70:3600"
	#
	# NOTE: Highest priority number wins.
	# These are not real ssid and psk passwords
	#
	network={
		ssid="ATT-WIRELESS"
		scan_ssid=1
		psk=zcf1es327molk7icjs61qvrdq8wemc42pfx4iupa0pd20oxqcuumjgvpcv8t5gui
		priority=10
	}
	network={
		ssid="HOME-WIFI-1"
		scan_ssid=1
		psk=c2u1anz3a0kpj64grgit9fmqdrskhfv98i25gh05wvty9gr8mvn604wx3ghicho6
		priority=9
	}
	network={
		ssid="HOME-WIFI-2"
		scan_ssid=1
		psk=4o4hrdc8rp3pw589fvk7kd8hkobkji5zp1p9fde9lynabhickc0qbi6nn4ot025n
		priority=9
	}

