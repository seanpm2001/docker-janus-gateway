#!/bin/bash
if [[ -z "${GATEWAY_IP}" ]]; then
  >&2 echo "Error: GATEWAY_IP environment variable is not set. Please set it to IP of the host that runs the Docker image"
  exit 1
fi

DOCKERIZE_COMMON_ARGS="-template /templates:/usr/local/etc/janus su app -c /usr/local/bin/janus"

if [[ "$RABBITMQ_ENABLED" == "true" ]]; then
  RABBITMQ_HOST="${RABBITMQ_HOST:-rabbitmq}"
  RABBITMQ_PORT="${RABBITMQ_PORT:-5672}"
  echo "RabbitMQ enabled, deferring boot until we can connect to $RABBITMQ_HOST:$RABBITMQ_PORT..."
  DOCKERIZE_EXTRA_ARGS="-wait tcp://$RABBITMQ_HOST:$RABBITMQ_PORT -timeout 60s"
else
  echo "RabbitMQ disabled"
fi

if [[ "$RABBITMQ_EVENTHANDLER_ENABLED" == "true" ]]; then
  RABBITMQ_EVENTHANDLER_HOST="${RABBITMQ_EVENTHANDLER_HOST:-rabbitmq}"
  RABBITMQ_EVENTHANDLER_PORT="${RABBITMQ_EVENTHANDLER_PORT:-5672}"
  echo "RabbitMQ event handler enabled, deferring boot until we can connect to $RABBITMQ_EVENTHANDLER_HOST:$RABBITMQ_EVENTHANDLER_PORT..."
  DOCKERIZE_EXTRA_ARGS="$DOCKERIZE_EXTRA_ARGS -wait tcp://$RABBITMQ_EVENTHANDLER_HOST:$RABBITMQ_EVENTHANDLER_PORT -timeout 60s"
else
  echo "RabbitMQ event handler disabled"
fi

dockerize $DOCKERIZE_EXTRA_ARGS $DOCKERIZE_COMMON_ARGS
