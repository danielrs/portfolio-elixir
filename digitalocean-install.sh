# Install packages as root
if [ "$EUID" -ne 0]; then
  # Starts su
  echo "the scripts needs the root pasword for installing packages..."
  sudo su -s "$0"

  # Adds Erlang repo
  wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
  apt-get update

  # Install packages
  apt-get install --asume-yes build-essential
  apt-get install --asume-yes esl-erlang
  apt-get install --asume-yes elixir
  apt-get install --asume-yes postgresql postgresql-contrib
  apt-get install --asume-yes git

  # Exists su
  exit
  echo "Exited su..."
fi

# Installs nvm for current user
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
