defmodule Portfolio.API.V1.PostView do
  use Portfolio.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, API.V1.PostView, "post.json", ignore: :markdown)}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, API.V1.PostView, "post.json")}
  end

  def render("post.json", %{post: post} = params) do
    ignores = Map.get(params, :ignore) |> List.wrap
    %{id: post.id,
      title: post.title,
      slug: post.slug,
      markdown: post.markdown,
      html: post.html,
      date: post.date,
      published?: post.published?,
      user_id: post.user_id}
    |> Map.drop(ignores)
  end
end
