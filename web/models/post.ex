defmodule Portfolio.Post do
  use Portfolio.Web, :model
  use Portfolio.Filtrable

  alias Portfolio.Repo
  alias Portfolio.Tag

  require Logger

  schema "posts" do
    field :title, :string
    field :slug, :string
    field :markdown, :string
    field :html, :string
    field :date, Ecto.Date
    field :published?, :boolean, default: false

    belongs_to :user, Portfolio.User
    many_to_many :tags, Portfolio.Tag,
      join_through: "posts_tags",
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
    |> put_tags(params)
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

  # Check: http://blog.plataformatec.com.br/2016/12/many-to-many-and-upserts/
  # TODO: Update to upserts after updating to ecto >= 2.1
  defp put_tags(changeset, params) do
    if changeset.valid? do
      tags =
        (params["tags"] || [])
        |> List.wrap
        |> Enum.map(& Tag.changeset(%Tag{}, %{name: &1}))
        |> Enum.filter(& &1.valid?)

      if length(tags) > 0 do
        tags = tags |> Enum.map(&get_or_insert_tag/1)
        Logger.debug "HERE"
        Logger.debug inspect(tags)

        changeset
        |> put_assoc(:tags, tags)
      else
        changeset
      end
    else
      changeset
    end
  end

  defp get_or_insert_tag(tag) do
    Repo.get_by(Tag, name: tag.changes.name) || maybe_insert_tag(tag)
  end

  defp maybe_insert_tag(tag) do
    tag
    |> Repo.insert
    |> case do
      {:ok, tag} -> tag
      {:error, _} -> Repo.get_by!(Tag, name: tag.changes.name)
    end
  end

  #
  # Queries
  #

  @spec query_posts([user_id: String.t]) :: Ecto.Queryable.t
  def query_posts(opts \\ []) do
    tags_query = from t in Tag, order_by: t.name
    posts = from p in Portfolio.Post,
      join: u in assoc(p, :user),
      join: r in assoc(u, :role),
      left_join: t in assoc(p, :tags),
      preload: [user: {u, role: r}, tags: ^tags_query]
  end
end
