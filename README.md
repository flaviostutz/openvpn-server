# openvpn-server
OpenVPN server container. Based on https://github.com/kylemanna/docker-openvpn

## Server Usage

* Create docker-compose.yml file

```yml
version: '3.5'
services:
  openvpn-server:
    build: .
    environment:
      - PUBLIC_CONNECTION_URL=tcp://192.168.20.23:1194
    ports:
      - 1194:1194
    privileged: true
    volumes:
      - ./openvpn-etc:/etc/openvpn
```

* Remember to replace the IP above with your own public IP and PORT that allows access to the machine this container is running (NAT etc)

* Create volume dir with ```mkdir ./openvpn-etc```

* Run ```docker-compose up -d```

* Copy OpenVPN client configuration from "./openvpn-etc/openvpn-client.ovpn" to the client machines

## Client Usage

* Get openvpn-client.ovpn file from the server machine (pen drive, email etc)

### Windows

* Download OpenVPN for Windows from https://openvpn.net/community-downloads/
* Click with the right button on installer and "Execute as Administrator" to begin installation
* After installation, click on Start Menu "TAP-Windows -> Utilities -> Add New Tap..."
* Locate icon on task bar and select "Import config file" and select the openvpn-client.ovpn file
* After successful import, right click on task bar icon, select "openvpn-client" -> "Connect"
* Now you should be connected to remote network

## ENVs

* PUBLIC_CONNECTION_URL - Connection URL for connecting to this server. Used for generating the client configuration files at /etc/openvpn/openvpn-client.ovpn. Describe the URL in format [udp/tcp]://[your-public-ip]:[your-public-port]. Required.

* PUSH_DEFAULT_GATEWAY - Whatever push an instruction to clients telling them to route all its traffic through this VPN connection of just routes defined by PUSH_CLIENT ROUTE. defaults to 'false'

* PUSH_CLIENT_ROUTE - Routes defined here will be used by client machines to decide on which local traffic will be routed through the VPN, so that it arrives the server. defaults to '192.168.1.0 255.255.255.0'

* PUSH_CLIENT_ROUTE2 - additional client route

* PUSH_CLIENT_ROUTE3 - additional client route
