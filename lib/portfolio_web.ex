defmodule PortfolioWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use PortfolioWeb, :controller
      use PortfolioWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      defp cast_date(date) do
        case Ecto.Date.cast(date) do
          {:ok, new_date} -> new_date
            _ -> date
        end
      end
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: PortfolioWeb

      import Plug.Conn
      import PortfolioWeb.Router.Helpers
      import PortfolioWeb.Gettext

      # Extra
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]
      alias Portfolio.Repo
      alias Portfolio.SEO
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/portfolio_web/templates",
                        namespace: PortfolioWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import PortfolioWeb.Router.Helpers
      import PortfolioWeb.ErrorHelpers
      import PortfolioWeb.Gettext

      # Extra
      alias PortfolioWeb.API
      alias Portfolio.LanguageColor
      use Portfolio.SEO
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import PortfolioWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
