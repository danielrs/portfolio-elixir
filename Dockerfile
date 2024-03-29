FROM trenpixster/elixir:1.5

#
# System dependencies
#

# Install curl, inotify-tools (for phoenix), and silversearcher
RUN apt-get update && apt-get install -y \
    curl \
    inotify-tools \
    silversearcher-ag \
    && rm -rf /var/lib/apt/lists/*

# Creates app folder and user
RUN mkdir /app \
    && useradd -m app \
    && chown app /app

ENV HOME /home/app

WORKDIR /app
ADD . .
RUN chown -R app .
USER app

# Install nvm
ENV NVM_DIR $HOME/nvm
ENV NODE_VERSION 7.5.0

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install Elixir's rebar, hex, and phoenix
RUN mix local.rebar --force \
    && mix local.hex --force \
    && mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force

#
# Deploy
#

# Gets dependencies
RUN mix deps.get

# Compiles app
RUN MIX_ENV=prod mix compile

# Compiles assets
RUN cd ./assets \
    && npm install \
    && NODE_ENV=production ./node_modules/.bin/brunch build --production
RUN MIX_ENV=prod mix phoenix.digest

# Exposes port from docker container to host
EXPOSE 4000

# The command to run when this image starts up
CMD mix ecto.create \
    && mix ecto.migrate \
    && MIX_ENV=prod mix phoenix.server
