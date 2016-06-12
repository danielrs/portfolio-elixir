# Install packages as root
echo "the scripts needs the root pasword for installing packages..."
sudo -s <<EOF
  echo "Entered root..."

  # Adds Erlang repo
  wget -P /tmp/erlang-solutions/ https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i /tmp/erlang-solutions/erlang-solutions_1.0_all.deb
  apt-get update

  # Install packages
  apt-get install --assume-yes build-essential
  apt-get install --assume-yes esl-erlang
  apt-get install --assume-yes elixir
  apt-get install --assume-yes postgresql postgresql-contrib
  apt-get install --assume-yes git

  echo "Exiting root..."
EOF

# Install hex and rebar locally
yes | mix local.hex
yes | mix local.rebar

# Installs nvm for current user
curl https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
