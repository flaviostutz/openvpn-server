#!/bin/sh

set -e

if [ "$DEBUG" == "1" ]; then
    set -x
fi

if [ ! -f /etc/openvpn/init ]; then

    rm -rf /etc/openvpn/*

    echo ">>> Generating OpenVPN server configuration..."
    if [ "$PUBLIC_CONNECTION_URL" == "udp://localhost:1194" ]; then
        echo "You have to define ENV PUBLIC_CONNECTION_URL in format [proto]://[host]:[port]. Ex.: udp://myovpnserver:1194"
        exit 1
    fi
    export DG="-d"
    if [ "$PUSH_DEFAULT_GATEWAY" == "true" ]; then
        export DG=""
    fi
    export PC1=""
    if [ "$PUSH_CLIENT_ROUTE" != "" ]; then
        export PC1="-proute $PUSH_CLIENT_ROUTE"
    fi
    export PC2=""
    if [ "$PUSH_CLIENT_ROUTE2" != "" ]; then
        export PC2="-proute $PUSH_CLIENT_ROUTE2"
    fi
    export PC3=""
    if [ "$PUSH_CLIENT_ROUTE3" != "" ]; then
        export PC3="-proute $PUSH_CLIENT_ROUTE3"
    fi
    ovpn_genconfig -u $PUBLIC_CONNECTION_URL "$DG" "$PC1" "$PC2" "$PC3"



    echo ">>> Initializing PKI..."
    #the code below emulates user interaction
    (echo -en "\n\n\n\n\n\n\n\n"; sleep 1; echo -en "\n"; sleep 1; echo -en "\n"; sleep 3; echo -en "yes"; echo -en "\n"; sleep 3; echo -en "yes"; echo -en "\n") | ovpn_initpki nopass



    echo ">>> Generating OpenVPN client configuration..."
    easyrsa build-client-full $CLIENTNAME nopass
    ovpn_getclient $CLIENTNAME > /etc/openvpn/$CLIENTNAME.ovpn

    if [ "$PUSH_CLIENT_ROUTE" != "" ];then
        echo "route $PUSH_CLIENT_ROUTE" >> /etc/openvpn/$CLIENTNAME.ovpn
    fi
    
    if [ "$PUSH_CLIENT_ROUTE2" != "" ];then
        echo "route $PUSH_CLIENT_ROUTE2" >> /etc/openvpn/$CLIENTNAME.ovpn
    fi
    
    if [ "$PUSH_CLIENT_ROUTE3" != "" ];then
        echo "route $PUSH_CLIENT_ROUTE3" >> /etc/openvpn/$CLIENTNAME.ovpn
    fi
    

    touch /etc/openvpn/init

else
    echo "Reusing OpenVPN configuration files"
fi

echo "/etc/openvpn/openvpn.conf"
cat /etc/openvpn/openvpn.conf

echo ">>> Starting OpenVPN server..."
ovpn_run

