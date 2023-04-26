FROM registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:a8870aa60b45495d298df5b65c69b3d7972608da4367bd6e69d6e392ac969dd4

USER root

# Tanzu CLI
ADD tanzu-framework-linux-amd64-v0.28.1.1.tar /tmp
RUN mv $(find /tmp/ -name 'tanzu-core-linux_amd64' -print0) /usr/local/bin/tanzu && \
  chmod 755 /usr/local/bin/tanzu && \
  tanzu plugin install --local /tmp/cli/ all && \
  chmod -R 755 .config/tanzu

# TBS
RUN curl -L -o /usr/local/bin/kp https://github.com/vmware-tanzu/kpack-cli/releases/download/v0.10.0/kp-linux-amd64-0.10.0 && \
  chmod 755 /usr/local/bin/kp

# Install krew
RUN \
( \
  set -x; cd "$(mktemp -d)" && \
  OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
  KREW="krew-${OS}_${ARCH}" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
  tar zxvf "${KREW}.tar.gz" && \
  ./"${KREW}" install krew \
)
RUN echo "export PATH=\"${KREW_ROOT:-$HOME/.krew}/bin:$PATH\"" >> ${HOME}/.bashrc
ENV PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
RUN kubectl krew install tree
RUN kubectl krew install eksporter
RUN chmod 775 -R $HOME/.krew
RUN apt update
RUN apt install ruby-full -y

# Utilities
RUN apt-get update && apt-get install -y unzip moreutils

RUN chown -R eduk8s:users /home/eduk8s/.config

RUN rm -rf /tmp/*

USER 1001

RUN fix-permissions /home/eduk8s