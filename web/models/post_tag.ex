defmodule Portfolio.PostTag do
  use Portfolio.Web, :model

  schema "posts_tags" do
    belongs_to :post, Portfolio.Post
    belongs_to :tag, Portfolio.Tag
  end
end
