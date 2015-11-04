#!/bin/bash
set -e

APP_SCRIPT=${APP_SCRIPT:-application.py}
APP_REQUIREMENTS=${APP_REQUIREMENTS:-requirements.txt}
APP_PORT=${APP_PORT:-8080}

echo "Current directory: " $(pwd)
echo "Application script: " $APP_SCRIPT
echo "Application requirements: " $APP_REQUIREMENTS
echo "Application port: " $APP_PORT

echo "Preparing environment..."
pip install --upgrade -r $APP_REQUIREMENTS

echo "Starting application..."
pypy $APP_SCRIPT --port=$APP_PORT

exit 0
