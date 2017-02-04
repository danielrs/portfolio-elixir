FROM trenpixster/elixir:1.3.4

# Install curl inotify-tools (for phoenix)
RUN apt-get update && apt-get install -y \
    curl \
    inotify-tools

# USER root
# RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/9.3/main/pg_hba.conf
# RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Install nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 7.5.0

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install Elixir's rebar, hex, and phoenix
RUN mix local.rebar
RUN mix local.hex --force
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

# Creates app folder and user
RUN mkdir /app
RUN useradd -m -d /app app
RUN chown -R app /app

USER app
WORKDIR /app
