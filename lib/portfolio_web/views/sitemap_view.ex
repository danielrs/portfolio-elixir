defmodule PortfolioWeb.SitemapView do
  use PortfolioWeb, :view
  import Portfolio.Utils, only: [host: 0]

  def format_sitemap_date(date) do
    date
    |> Portfolio.Utils.format_date("{YYYY}-{0M}-{0D}")
  end
end
