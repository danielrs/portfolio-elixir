[danielrs.me]: http://danielrs.me/

[![danielrs.me](https://img.shields.io/website-up-down-green-red/http/danielrs.me.svg)][danielrs.me]

# Portfolio

This is the source code for the skeleton of my personal [website][danielrs.me]. It was made with *Elixir* and *PostgreSQL* for the back-end; and *React.js* and *LESS* for the front-end.

## Running the app

### Development

For easier development and deployment, I created a docker-compose setup. To start the containers use:

```
docker-compose up
```

After all the containers started, log in into the main container using:

```
docker-compose exec web bash
```

The web container has elixir, phoenix, and npm installed. To start your Phoenix app:

  * **If running the first time**, clean old dependencies with `mix deps.clean --all`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies for the active theme with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Deployment

NEED INSTRUCTIONS HERE.

## Todo

### Back-end

* Clean code.

### Front-end

* Add admin page for managing blog posts.
