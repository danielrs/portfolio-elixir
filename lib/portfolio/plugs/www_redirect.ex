# Check: http://www.holovaty.com/writing/aws-domain-redirection/
# And: http://stackoverflow.com/questions/35691974/redirect-elixir-phoenix-request-from-root-domain-to-www
#
defmodule Portfolio.Plug.WWWRedirect do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _options) do
    if not bare_domain?(conn.host) do
      conn
      |> Phoenix.Controller.redirect(external: bare_url(conn))
      |> halt
    else
      conn
    end
  end

  # Returns a new url without www. prepended.
  defp bare_url(conn) do
    bare_host = Regex.replace(~r/^www\./i, conn.host, "")
    if conn.port == 80 do
      "#{conn.scheme}://#{bare_host}#{conn.request_path}"
    else
      "#{conn.scheme}://#{bare_host}:#{conn.port}#{conn.request_path}"
    end
  end

  # Returns whether the domain is bare (no www)
  defp bare_domain?(host) do
    !Regex.match?(~r/^www\..*\z/i, host)
  end
end
