#!/bin/bash
set -x
set +e

kubectl annotate namespace ${SESSION_NAMESPACE} secretgen.carvel.dev/excluded-from-wildcard-matching-

kubectl patch serviceaccount default -p '{"secrets": [{"name": "registry-credentials"},{"name": "git-https"}], imagePullSecrets: [{"name": "registry-credentials"}]}'
kubectl apply -f ~/samples/scan-policy.yaml
