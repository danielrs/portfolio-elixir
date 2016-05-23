defmodule Portfolio.Plug.Social do
  @moduledoc false

  import Plug.Conn

  defmacrop social_network(networks, caption, url, icon) do
    quote do
      unquote(networks)
      ++ [%{caption: unquote(caption),
            url: unquote(url),
            icon: unquote(icon)}]
    end
  end

  def init(opts) do
    social = []
             |> social_network("Github",
                               "https://github.com/DanielRS",
                               "fa-github-alt")

             |> social_network("StackOverflow",
                               "http://stackoverflow.com/users/3932019/danielrs",
                               "fa-stack-overflow")

             |> social_network("LinkedIn",
                               "https://www.linkedin.com/in/daniel-rivas-364a6592",
                               "fa-linkedin")

             |> social_network("Twitter",
                               "https://twitter.com/devDanielRS",
                               "fa-twitter")

    Keyword.put(opts, :social, social)
  end

  def call(conn, opts) do
    conn
    |> assign(:social, Keyword.get(opts, :social))
  end
end
