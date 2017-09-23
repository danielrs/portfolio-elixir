defmodule Portfolio.BlogFilter do
  use PortfolioWeb, :model

  embedded_schema do
    field :tag, :string
    field :search, :string
  end

  @required_fields []
  @optional_fields [:tag, :search]

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> update_change(:tag, & String.downcase(&1))
    |> update_change(:search, & String.downcase(&1))
  end

  #
  # Queries
  #

  def query_posts(params) do
    blog_filter = changeset(%Portfolio.BlogFilter{}, params)

    if tag = get_change(blog_filter, :tag) do
      from p in Portfolio.Post.query_posts,
        join: t in assoc(p, :tags),
        where: t.name == ^tag
    else
      Portfolio.Post.query_posts
    end
  end
end
