defmodule Portfolio.SitemapView do
  use Portfolio.Web, :view

  def host do
    "http://#{Application.get_env(:portfolio, Portfolio.Endpoint)[:url][:host]}"
  end

  def format_sitemap_date(date) do
    date
    |> Portfolio.Utils.format_date("{YYYY}-{0M}-{0D}")
  end
end
