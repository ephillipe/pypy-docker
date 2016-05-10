#!/bin/bash
set -e

echo "Starting cron service"
service cron start

APP_SCRIPT=${APP_SCRIPT:-application.py}
APP_REQUIREMENTS=${APP_REQUIREMENTS:-/usr/src/app/requirements.txt}
APP_PORT=${APP_PORT:-8080}
CURRENT_DIR=$(pwd)
SOMAXCONN=${SOMAXCONN}

echo "Current directory: " $CURRENT_DIR
echo "Application script: " $APP_SCRIPT
echo "Application requirements: " $APP_REQUIREMENTS
echo "Application port: " $APP_PORT
export PYTHONPATH="${PYTHONPATH}":$CURRENT_DIR
echo "Current PYTHONPATH:" $PYTHONPATH

echo "Preparing environment..."
pip install --upgrade -r $APP_REQUIREMENTS

# Throws error if $SOMAXCONN is set and container not in --privileged mode
if ! [ -z "$SOMAXCONN" ]; then
    echo "Increasing somaxconn..."
    sysctl -w net.core.somaxconn=$SOMAXCONN
fi

echo "Starting application..."
exec "$@" $APP_SCRIPT --port $APP_PORT
