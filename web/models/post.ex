defmodule Portfolio.Post do
  use Portfolio.Web, :model
  use Portfolio.Filtrable

  schema "posts" do
    field :title, :string
    field :slug, :string
    field :markdown, :string
    field :html, :string
    field :date, Ecto.Date
    field :published?, :boolean, default: false

    belongs_to :user, Portfolio.User
    many_to_many :tags, Portfolio.Tag,
      join_through: Portfolio.PostTag,
      on_delete: :delete_all,
      on_replace: :delete

    timestamps
  end

  @required_fields [:title, :markdown, :date]
  @optional_fields [:slug, :html, :published?]
  @filtrable_fields [:date, :title, :slug, :markdown]

  @doc """
  Creates a changeset based on the `struct` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_slug
    |> cast_html
    |> update_change(:date, &cast_date(&1))
    |> unique_constraint(:slug, message: "already taken")
  end

  defp cast_slug(changeset) do
    if changeset.valid? do
      case {
        get_change(changeset, :slug),
        (changeset.params["slug"] || "") |> String.trim |> String.length,
        get_change(changeset, :title),
        get_field(changeset, :title)} do
          # New slug was provided
          {slug, _, _, _} when not is_nil(slug) ->
            changeset |> update_change(:slug, &(&1 |> slugify))

          # Same slug was provided
          {nil, len, _, _} when len > 0 ->
            changeset

          # No slug was provided, use title change
          {_, 0, title, _} when not is_nil(title) ->
            changeset |> put_change(:slug, title |> slugify)

          # No slug was provided, use field title
          {_, 0, _, title} when not is_nil(title) ->
            changeset |> put_change(:slug, title |> slugify)

          _ ->
            changeset |> add_error(:slug, "unable to extrapolate from title")
      end
    else
      changeset
    end
  end

  defp cast_html(changeset) do
    if changeset.valid? do
      if markdown = get_change(changeset, :markdown) do
        changeset |> put_change(:html, Earmark.as_html!(markdown))
      else
        changeset
      end
    else
      changeset
    end
  end

  defp slugify(string) when is_binary(string) do
    string
    |> String.downcase
    |> String.replace(~r/\s/, "-")
    |> String.replace(~r/[^-\p{L}0-9]/u, "")
    |> String.replace(~r/-+/, "-")
  end

  deffilter @filtrable_fields do
    def search_by(query, search_string) do
      from p in query,
      where: ilike(p.title, ^search_string)
      or ilike(p.slug, ^search_string)
    end

    def order_by(query, order_map) do
      query |> Ecto.Query.order_by(^order_map)
    end
  end

  #
  # Queries
  #

  @spec query_posts :: Ecto.Queryable.t
  def query_posts do
    tags_query = from t in Portfolio.Tag, order_by: t.name
    from p in Portfolio.Post,
      preload: [:user, user: :role, tags: ^tags_query]
  end
end
