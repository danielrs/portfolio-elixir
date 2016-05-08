defmodule Portfolio.PostView do
  use Portfolio.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, Portfolio.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, Portfolio.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      title: post.title,
      slug: post.slug,
      markdown: post.markdown,
      html: post.html,
      date: post.date,
      published: post.published,
      user_id: post.user_id}
  end
end
