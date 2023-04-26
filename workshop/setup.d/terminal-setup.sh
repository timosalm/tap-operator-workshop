#!/bin/bash
set -x
set +e

mkdir ~/exports

kubectl() {
    if [[ $@ == *"secret"* ]]; then
        command echo "No resources found in $SESSION_NAMESPACE namespace."
    else
        command kubectl "$@"
    fi
}

k() {
    if [[ $@ == *"secret"* ]]; then
        command echo "No resources found in $SESSION_NAMESPACE namespace."
    else
        command kubectl "$@"
    fi
}