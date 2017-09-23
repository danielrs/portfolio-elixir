defmodule PortfolioWeb.API.V1.PostView do
  use PortfolioWeb, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, API.V1.PostView, "post.json", ignore: [:markdown, :html])}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, API.V1.PostView, "post.json")}
  end

  def render("post.json", %{post: post} = params) do
    ignores = Map.get(params, :ignore) |> List.wrap
    %{id: post.id,
      title: post.title,
      slug: post.slug,
      description: post.description,
      markdown: post.markdown,
      html: post.html,
      date: Portfolio.Utils.format_date(post.date, "{YYYY}-{0M}-{0D}"),
      published?: post.published?,
      user:
        render_one(post.user, API.V1.UserView, "show.json")
        |> Map.get(:data),
      tags:
        render_one(post.tags, API.V1.TagView, "index.json", as: :tags)
        |> Map.get(:data)}
    |> Map.drop(ignores)
  end
end
