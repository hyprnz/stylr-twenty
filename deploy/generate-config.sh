#!/bin/bash

if [ ! -f ".env.local" ]; then
    echo "Error: .env.local file not found!"
    echo "Please create deploy/.env.local with your secrets"
    exit 1
fi

if [ ! -f "containers.template.json" ]; then
    echo "Error: containers.template.json not found!"
    exit 1
fi

set -a
source ".env.local"
set +a

# Replace variables in template
envsubst < containers.template.json > containers.json

echo "Generated 'containers.json' with variables from '.env.local'"
