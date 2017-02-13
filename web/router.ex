defmodule Portfolio.Router do
  use Portfolio.Web, :router
  import Portfolio.Plug.Setup
  import Portfolio.API.V1.Plugs

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

  pipeline :api_v1_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: Portfolio.API.V1.SessionController
    plug :ensure_guardian_resource_loaded
  end

  # User scope
  scope "/", Portfolio do
    pipe_through [:browser, :browser_user]

    get "/", HomeController, :index
    get "/projects", ProjectController, :index
    get "/contact", ContactController, :index
    post "/contact", ContactController, :create
    get "/blog", BlogController, :index
    get "/blog/:id", BlogController, :show_proxy
    get "/blog/:id/:slug", BlogController, :show

    get "/dashboard*path", DashboardController, :index
  end

  # Setup scope
  scope "/", Portfolio do
    pipe_through [:browser, :browser_setup]
    get "/setup", SetupController, :index
    post "/setup", SetupController, :create
  end

  # Api scope
  scope "/api", Portfolio.API do
    pipe_through :api

    scope "/v1", V1 do

      post "/session", SessionController, :create
      delete "/session", SessionController, :delete

      scope "/" do
        pipe_through :api_v1_auth
        get "/session", SessionController, :show

        resources "/users", UserController, except: [:new, :edit] do
          resources "/projects", ProjectController, except: [:new, :edit]
          resources "/posts", PostController, except: [:new, :edit]
        end

        resources "/tags", TagController, except: [:new, :edit]
      end
    end
  end

end
