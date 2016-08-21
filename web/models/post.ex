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
    many_to_many :tags, Portfolio.Tag, join_through: "posts_tags"

    timestamps
  end

  @required_fields [:title, :markdown, :date]
  @optional_fields [:slug, :html, :published?]
  @filtrable_fields [:date, :title, :slug, :markdown]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_slug
    |> cast_html
    |> update_change(:date, &cast_date(&1))
    |> unique_constraint(:slug, message: "already taken")
  end

  defp cast_slug(changeset) do
    if changeset.valid? do
      if get_change(changeset, :slug) do
        changeset |> update_change(:slug, &slugify(&1))
      else
        changeset |> put_change(:slug, get_change(changeset, :title) |> slugify)
      end
    else
      changeset
    end
  end

  defp cast_html(changeset) do
    if markdown = get_change(changeset, :markdown) do
      changeset |> put_change(:html, Earmark.to_html(markdown))
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
end
