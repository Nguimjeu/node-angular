ARG NODE_VERSION

FROM node:${NODE_VERSION}-alpine

ARG USER_ID
ARG GROUP_ID
ARG USERNAME
ARG GROUP_NAME
ARG NPM_VERSION

RUN apk add --no-cache \
    wget \
    curl \
    nano \
    npm \
    bash \
    bash-completion \
    sudo \
    chromium \
    shadow && \
    npm install -g npm@${NPM_VERSION} && \
    npm install -g @angular/cli && \
    npm install -g @ionic/cli

RUN set -xe; \
    \
    # Create group if on only if group identified by GID not occupied.
    existing_group=$(getent group "${GROUP_ID}" | cut -d: -f1); \
    if [[ -n "${existing_group}" ]]; then \
      echo "The group with GID ${GROUP_ID} already exists. Skipping group creation."; \
      GROUP_NAME=$existing_group; \
    else \
      /usr/sbin/groupadd --gid "${GROUP_ID}" "${GROUP_NAME}" --force; \
    fi; \
    # Create user if on only if user identified by UID not occupied.
    existing_user=$(getent passwd "${USER_ID}" | cut -d: -f1); \
    if [[ -n "${existing_user}" ]]; then \
      echo "The user with UID ${USER_ID} already exists. Skipping user creation."; \
      USERNAME=$existing_user; \
    else \
      /usr/sbin/useradd --create-home --shell /bin/bash --gid "${GROUP_ID}" --uid ${USER_ID} "${USERNAME}"; \
    fi; \
    \
    echo "${USERNAME} ALL=(root) NOPASSWD:ALL" >/etc/sudoers.d/"${USERNAME}"; \
    echo chmod 0440 /etc/sudoers.d/"${USERNAME}";

#COPY ./.bashrc /home/${USERNAME}/.bashrc
#COPY ./.profile /home/${USERNAME}/.profile
#COPY ./.bash_aliases /home/${USERNAME}/.bash_aliases

RUN echo "uid=${USER_ID}(${USERNAME}) gid=${GROUP_NAME}(${GROUP_ID})";

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

#RUN chown $USERNAME:$GROUP_NAME /home/${USERNAME}/.bashrc \
#    /home/${USERNAME}/.profile \
#    /home/${USERNAME}/.bash_aliases

#RUN chown -R $USERNAME: /usr/local/{lib/node_modules,bin,share}

USER $USERNAME
