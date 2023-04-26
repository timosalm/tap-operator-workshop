#!/bin/bash
set -x
set +e

jq ". + { \"redhat.telemetry.enabled\": false, \"vs-kubernetes.ignore-recommendations\": true}" /home/eduk8s/.local/share/code-server/User/settings.json | sponge /home/eduk8s/.local/share/code-server/User/settings.json