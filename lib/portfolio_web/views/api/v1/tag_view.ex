defmodule PortfolioWeb.API.V1.TagView do
  use PortfolioWeb, :view

  def render("index.json", %{tags: tags}) do
    %{data: render_many(tags, API.V1.TagView, "tag.json")}
  end

  def render("show.json", %{tag: tag}) do
    %{data: render_one(tag, API.V1.TagView, "tag.json")}
  end

  def render("tag.json", %{tag: tag}) do
    %{
      id: tag.id,
      name: tag.name
    }
  end
end
