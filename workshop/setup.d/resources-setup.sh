kubectl patch serviceaccount default -p '{"secrets": [{"name": "registry-credentials"},{"name": "git-https"}]}'
