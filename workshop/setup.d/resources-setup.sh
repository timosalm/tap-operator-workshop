#!/bin/bash
set -x
set +e

kubectl patch serviceaccount default -p '{"secrets": [{"name": "registry-credentials"},{"name": "git-https"}]}'
kubectl apply -f samples/scan-policy.yaml
kubectl apply -f samples/test-pipeline.yaml
