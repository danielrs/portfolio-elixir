defmodule Portfolio.SEO do

  @spec put_title(Plug.Conn.t, String.t) :: Plug.Conn.t
  def put_title(conn, title) do
    if title && String.strip(title) == "" do
      Plug.Conn.assign(conn, :title, default_title)
    else
      Plug.Conn.assign(conn, :title, title <> " - " <> site_name)
    end
  end

  @spec put_meta(Plug.Conn.t, String.t) :: Plug.Conn.t
  def put_meta(conn, meta) do
    if meta && String.strip(meta) != "" do
      Plug.Conn.assign(conn, :meta, meta)
    else
      conn
    end
  end

  def default_title, do: site_name
  def default_meta do
    """
    My personal programmer website. Take a look at either
    my personal projects or blog posts.
    """
  end

  # Gets current site name from application config.
  def site_name, do: Application.get_env(:portfolio, :site_name)

  defmacro __using__(_) do
    quote do
      import Portfolio.SEO
    end
  end
end
