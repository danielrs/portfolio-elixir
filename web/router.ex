defmodule Portfolio.Router do
  use Portfolio.Web, :router
  import Portfolio.Plug.Setup

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_user do
    plug Portfolio.Plug.RequestPath
    plug Portfolio.Plug.Social
    plug :ensure_setup
  end

  pipeline :browser_setup do
    plug :ensure_not_setup
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: Portfolio.SessionController
    plug Portfolio.Plug.EnsureGuardianResourceLoaded
  end

  # User scope
  scope "/", Portfolio do
    pipe_through [:browser, :browser_user]

    get "/", HomeController, :index
    get "/projects", ProjectShowcaseController, :index
    get "/contact", ContactController, :index
    post "/contact", ContactController, :create
    get "/blog", BlogController, :index

    get "/dashboard*path", DashboardController, :index
  end

  # Setup scope
  scope "/", Portfolio do
    pipe_through [:browser, :browser_setup]
    get "/setup", SetupController, :index
    post "/setup", SetupController, :create
  end

  # Api scope
  scope "/api", Portfolio do
    pipe_through :api

    scope "/v1" do
      post "/session", SessionController, :create
      delete "/session", SessionController, :delete
      scope "/" do
        pipe_through :api_auth
        get "/session", SessionController, :show
        resources "/users", UserController, except: [:new, :edit] do
          resources "/projects", ProjectController, except: [:new, :edit]
          resources "/posts", PostController, except: [:new, :edit]
        end
      end
    end
  end

end
