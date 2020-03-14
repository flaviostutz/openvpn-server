FROM kylemanna/openvpn

RUN apk add --no-cache expect

EXPOSE 1194/tcp

ENV PUBLIC_CONNECTION_URL 'udp://localhost:1194'
ENV CLIENTNAME 'openvpn-client'
ENV DEBUG '0'

ENV PUSH_DEFAULT_GATEWAY 'false'
ENV PUSH_CLIENT_ROUTE '192.168.1.0 255.255.255.0'
ENV PUSH_CLIENT_ROUTE2 ''
ENV PUSH_CLIENT_ROUTE3 ''

ADD startup.sh /

CMD [ "/startup.sh" ]

