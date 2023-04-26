#!/bin/bash
set -x
set +e

jq ". + { \"redhat.telemetry.enabled\": false }" /home/eduk8s/.local/share/code-server/User/settings.json | sponge /home/eduk8s/.local/share/code-server/User/settings.json