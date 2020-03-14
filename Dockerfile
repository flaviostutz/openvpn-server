FROM kylemanna/openvpn

RUN apk add --no-cache expect

EXPOSE 1194/tcp

ENV PUBLIC_CONNECTION_URL 'udp://localhost:1194'
ENV CLIENTNAME 'openvpn-client'
ENV DEBUG '0'

ENV PUSH_DEFAULT_GATEWAY 'false'
ENV PUSH_CLIENT_ROUTE '10.0.0.0 255.0.0.0'
ENV PUSH_CLIENT_ROUTE2 '192.168.0.0 255.25.0.0'
ENV PUSH_CLIENT_ROUTE3 '172.16.0.0 255.240.0.0'

ADD startup.sh /

CMD [ "/startup.sh" ]

