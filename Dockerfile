FROM registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:a8870aa60b45495d298df5b65c69b3d7972608da4367bd6e69d6e392ac969dd4

USER root

# Tanzu CLI
ADD tanzu-framework-linux-amd64-v0.28.1.1.tar /tmp
RUN mv $(find /tmp/ -name 'tanzu-core-linux_amd64' -print0) /usr/local/bin/tanzu && \
  chmod 755 /usr/local/bin/tanzu && \
  tanzu plugin install --local /tmp/cli/ all && \
  chmod -R 755 .config/tanzu

RUN rm -rf /tmp/*

USER 1001

RUN fix-permissions /home/eduk8s