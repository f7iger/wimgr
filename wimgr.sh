#!/usr/local/bin/zsh

help(){
cat <<EOF
USAGE:
	sh wimgr.sh <SSID> <password>
EOF
}

#Verify if ifconfig command exists
verify(){
	CMD="$(which ifconfig)"
	if [  -z "$CMD"  ]
	then
		echo "ifconfig not found"
		exit 1
	else
		return 0;
	fi
}

#Get Wireless Interface
gwi(){ 
	ifconfig |cut -d" " -f1|\
	egrep -v "^[[:space:]]"|\
	head -n2| tail -n1| sed 's/://'
}

cmd(){
	ifconfig $1 nwid $2 wpakey $3
}

verify

if [ $(whoami) != "root" ]
then
	echo "This operations require super user privileges"
	help
else
	if [ -z "$1" ]
	then
		echo "Inform the SSID for the network to connect"
		help
	elif [ -z "$2"  ]
	then
		echo "Enter the password for the network: $1"
		help
	else
		cmd $(gwi) $1 $2
		echo "Successfully connected"
	fi
fi
