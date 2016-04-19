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

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: Portfolio.SessionController
  end

  scope "/", Portfolio do
    pipe_through [:browser, :browser_user]

    get "/", HomeController, :index
    get "/projects", ProjectsController, :index
    get "/contact", ContactController, :index
    post "/contact", ContactController, :new
    get "/blog", BlogController, :index
    get "/dashboard*path", DashboardController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Portfolio do
    pipe_through :api

    scope "/v1" do
      post "/session", SessionController, :create
      delete "/session", SessionController, :delete
      scope "/" do
        pipe_through :api_auth
        get "/session", SessionController, :show
        resources "/projects", ProjectController, except: [:edit, :new]
      end
    end
  end

end
