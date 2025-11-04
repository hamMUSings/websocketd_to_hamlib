FROM alpine:3.22.2
RUN apk add hamlib websocketd bash
RUN adduser -SD websocketd
RUN mkdir /opt/websocket-hamlib
COPY *.sh /opt/websocket-hamlib/
WORKDIR /opt/websocket-hamlib/
CMD websocketd --port 2020 ./wsmanager.sh

