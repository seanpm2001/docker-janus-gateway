# Janus Gateway - Docker Image

This repository contains a scripts necessary to build a Docker image of the 
[Janus Gateway](https://janus.conf.meetecho.com/).

It aims to create a high-quality image that allows to run the gateway. By high
quality we mean in particular:

* being able to fully configure Janus Gateway over environment variables,
* mitigating issues that might arise if other dependentn services such as RabbitMQ 
  are not ready upon Janus boot time,
* being able to easily build custom plugins on top of this image,
* being able to monitor the gateway.

# Status

This is work in progress.

# Versioning scheme

The image is named `swmansion/janus:JANUS_VERSION-REVISION`, where revision is
being incremented from 0. 

# Building

```
docker build -t swmansion/janus:0.9.1-0 0.9.1
```

# Usage

## Sample

```
docker run --rm -e GATEWAY_IP=192.168.0.123 -e WEBSOCKETS_ENABLED=true -e RTP_PORT_RANGE=10000-10099 -p 8188:8188 -p 10000-10099:10000-10099/udp -ti swmansion/janus:0.9.1-0
```

(replace 192.168.0.123 with your IP)

## Environment variables

Some of the environment variable names or default values were altered compared 
to the original configuration files in order to provide more consistent usage.

### Gateway itself

#### Required options

* GATEWAY_IP - IP address to use, set it to the IP of the Docker host or if you're using 1:1 NAT (e.g. Amazon EC2) to the public IP of the machine.

#### Logging

* DEBUG_LEVEL - Log level, 0-7 (default=4),
* DEBUG_COLORS - Whether colors should be disabled in the log (default=true),
* DEBUG_LOCKS - Whether to enable debugging of locks (very verbose!, default=false)

### Media-related

* MIN_NACK_QUEUE - the minimum size of the NACK queue (in ms, defaults to 200ms) for retransmissions no matter the RTT
* RTP_PORT_RANGE - the range of ports to use for RTP and RTCP (default=10000-20000)
* DTLS_MTU - the starting MTU for DTLS (1200 by default, it adapts automatically)
* NO_MEDIA_TIMER - how much time, in seconds, should pass with no media (audio or video) being received before Janus notifies you about this (default=1s, 0 disables these events entirely)
* SLOWLINK_THRESHOLD - how many lost packets should trigger a 'slowlink' event to users (default=4)
* TWCC_PERIOD - how often, in milliseconds, to send the Transport Wide Congestion Control feedback information back to senders, if negotiated (default=200ms)

### NAT

* STUN_SERVER - STUN server address to use (default=stun.l.google.com)
* STUN_PORT - STUN server port to use (default=19302)

### RabbitMQ

See [janus.transport.rabbitmq.jcfg.sample](https://github.com/meetecho/janus-gateway/blob/v0.9.1/conf/janus.transport.rabbitmq.jcfg.sample) 
in Janus Gateway's source code for detailed explanation of the parameters.

* RABBITMQ_ENABLED - Whether the support must be enabled (default=false),
* RABBITMQ_EVENTS - Whether to notify event handlers about transport events (default=true),
* RABBITMQ_JSON - Whether the JSON messages should be indented (default), plain (no indentation) or compact (no indentation and no spaces),
* RABBITMQ_HOST - The address of the RabbitMQ server,
* RABBITMQ_PORT - The port of the RabbitMQ server (5672 by default)
* RABBITMQ_USERNAME - Username to use to authenticate, if needed
* RABBITMQ_PASSWORD - Password to use to authenticate, if needed
* RABBITMQ_VHOST - Virtual host to specify when logging in, if needed
* RABBITMQ_TO_JANUS - Name of the queue for incoming messages (default=to-janus)
* RABBITMQ_FROM_JANUS - Name of the queue for outgoing messages (default=from-janus)
* RABBITMQ_EXCHANGE - Exchange for outgoing messages, using default if not provided (default=wembrane)
* RABBITMQ_SSL_ENABLED - Whether ssl support must be enabled
* RABBITMQ_SSL_VERIFY_PEER - Whether peer verification must be enabled
* RABBITMQ_SSL_VERIFY_HOSTNAME - Whether hostname verification must be enabled
* RABBITMQ_SSL_CACERT - Path to cacert.pem
* RABBITMQ_SSL_CERT - Path to cert.pem
* RABBITMQ_SSL_KEY - Path to key.pem
* RABBITMQ_ADMIN_ENABLED - Whether the support must be enabled
* RABBITMQ_TO_JANUS_ADMIN - Name of the queue for incoming messages
* RABBITMQ_FROM_JANUS_ADMIN - Name of the queue for outgoing messages

* RABBITMQ_EVENTHANDLER_ENABLED - Whether events should be delivered over RabbitMQ (default=false)
* RABBITMQ_EVENTHANDLER_EVENTS - Comma separated list of the events mask you're interested in. Valid values are none, sessions, handles, jsep, webrtc, media, plugins, transports, core, external and all. By default we subscribe to everything (all)
* RABBITMQ_EVENTHANDLER_GROUPING - Whether events should be sent individually , or if it's ok to group them. The default is 'true' to limit the number of messages
* RABBITMQ_EVENTHANDLER_JSON - Whether the JSON messages should be indented (default), plain (no indentation) or compact (no indentation and no spaces
* RABBITMQ_EVENTHANDLER_HOST - The address of the RabbitMQ server,
* RABBITMQ_EVENTHANDLER_PORT - The port of the RabbitMQ server (5672 by default)
* RABBITMQ_EVENTHANDLER_USERNAME - Username to use to authenticate, if needed
* RABBITMQ_EVENTHANDLER_PASSWORD - Password to use to authenticate, if needed
* RABBITMQ_EVENTHANDLER_VHOST - Virtual host to specify when logging in, if needed
* RABBITMQ_EVENTHANDLER_ROUTE_KEY - Name of the queue for incoming messages (default=from-janus-event)
* RABBITMQ_EVENTHANDLER_EXCHANGE - Exchange for outgoing messages, using default if not provided (default=wembrane)
* RABBITMQ_EVENTHANDLER_SSL_ENABLED - Whether ssl support must be enabled
* RABBITMQ_EVENTHANDLER_SSL_VERIFY_PEER - Whether peer verification must be enabled
* RABBITMQ_EVENTHANDLER_SSL_VERIFY_HOSTNAME - Whether hostname verification must be enabled
* RABBITMQ_EVENTHANDLER_SSL_CACERT - Path to cacert.pem
* RABBITMQ_EVENTHANDLER_SSL_CERT - Path to cert.pem
* RABBITMQ_EVENTHANDLER_SSL_KEY - Path to key.pem

### WebSockets

See [janus.transport.websockets.jcfg.sample](https://github.com/meetecho/janus-gateway/blob/v0.9.1/conf/janus.transport.websockets.jcfg.sample) 
in Janus Gateway's source code for detailed explanation of the parameters.

* WEBSOCKETS_ENABLED - Whether to enable the WebSockets API (default=false)
* WEBSOCKETS_EVENTS - Whether to notify event handlers about transport events (default=true)
* WEBSOCKETS_JSON - Whether the JSON messages should be indented (default), plain (no indentation) or compact (no indentation and no spaces),
* WEBSOCKETS_PINGPONG_TRIGGER - After how many seconds of idle, a PING should be sent
* WEBSOCKETS_PINGPONG_TIMEOUT - After how many seconds of not getting a PONG, a timeout should be detected
* WEBSOCKETS_PORT - WebSockets server port
* WEBSOCKETS_INTERFACE - Whether we should bind this server to a specific interface only (FIXME: currently has no effect)
* WEBSOCKETS_IP - Whether we should bind this server to a specific IP address only (FIXME: currently has no effect)
* WEBSOCKETS_SSL_ENABLED - Whether to enable secure WebSockets
* WEBSOCKETS_SSL_PORT - WebSockets server secure port, if enabled
* WEBSOCKETS_SSL_INTERFACE - Whether we should bind this server to a specific interface only (FIXME: currently has no effect)
* WEBSOCKETS_SSL_IP - Whether we should bind this server to a specific interface only (FIXME: currently has no effect)
* WEBSOCKETS_ACL - Only allow requests coming from this comma separated list of addresses (FIXME: currently has no effect)
* WEBSOCKETS_LOGGING - libwebsockets debugging level as a comma separated list of things to debug, supported values: err, warn, notice, info, debug, parser, header, ext, client, latency, user, count (plus 'none' and 'all')
* WEBSOCKETS_ADMIN_ENABLED - Whether to enable the Admin API WebSockets API (default=false)
* WEBSOCKETS_ADMIN_PORT - Admin API WebSockets server port, if enabled
* WEBSOCKETS_ADMIN_INTERFACE - Whether we should bind this server to a specific interface only (FIXME: currently has no effect)
* WEBSOCKETS_ADMIN_IP - Whether we should bind this server to a specific IP address only (FIXME: currently has no effect)
* WEBSOCKETS_ADMIN_SSL_ENABLED - Whether to enable the Admin API secure WebSockets
* WEBSOCKETS_ADMIN_SSL_PORT - Admin API WebSockets server secure port, if enabled
* WEBSOCKETS_ADMIN_SSL_INTERFACE - Whether we should bind this server to a specific interface only (FIXME: currently has no effect)
* WEBSOCKETS_ADMIN_SSL_IP - Whether we should bind this server to a specific IP address only (FIXME: currently has no effect)
* WEBSOCKETS_ADMIN_ACL - Only allow requests coming from this comma separated list of addresses (FIXME: currently has no effect)
* WEBSOCKETS_SSL_CERT_PEM - If SSL is enabled, path to certificate's PEM file
* WEBSOCKETS_SSL_CERT_KEY - If SSL is enabled, path to certificate's key file
* WEBSOCKETS_SSL_CERT_PWD - If SSL is enabled, certificate's passphrase

## Copyright and License

Copyright 2020, [Software Mansion](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=docker-janus)

[![Software Mansion](https://logo.swmansion.com/logo?color=white&variant=desktop&width=200&tag=docker-janus-github)](
https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=docker-janus)

Please note that underlying software contained in the image might have 
different licenses, most importantly Janus Gateway is 
[licensed under GPLv3](https://janus.conf.meetecho.com/docs/COPYING.html).

The code located in this repository is licensed under the [Apache License, Version 2.0](LICENSE).