defmodule Portfolio.Router do
  use Portfolio.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_user do
    plug Portfolio.Plug.Social
  end

  pipeline :browser_admin do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: Portfolio.SessionController
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", Portfolio do
    pipe_through [:browser, :browser_user]

    get "/", HomeController, :index
    get "/projects", ProjectsController, :index
    get "/contact", ContactController, :index
    post "/contact", ContactController, :new
    get "/blog", BlogController, :index
  end

  scope "auth", Portfolio do
    pipe_through [:browser, :browser_user]

    get "/", SessionController, :index
    post "/", SessionController, :create
    get "/logout", SessionController, :delete
  end

  scope "/dashboard", Portfolio.Admin, as: :admin do
    pipe_through [:browser, :browser_admin]

    get "/", HomeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Portfolio do
  #   pipe_through :api
  # end
end
