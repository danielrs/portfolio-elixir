defmodule Portfolio.Post do
  use Portfolio.Web, :model
  alias Portfolio.Post

  schema "posts" do
    field :title, :string
    field :slug, :string
    field :markdown, :string
    field :html, :string
    field :date, Ecto.Date
    field :published, :boolean, default: false
    belongs_to :user, Portfolio.User

    timestamps
  end

  @required_fields ~w(title markdown date user_id)
  @optional_fields ~w(slug html published)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_slug
    |> unique_constraint(:slug)
    |> update_change(:date, &cast_date(&1))
    |> put_html
  end

  def order_by_date(query \\ %Post{}) do
    from p in query,
    order_by: [desc: p.date]
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

  defp put_html(changeset) do
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
    |> String.replace(~r/[^-\p{L}]/u, "")
  end
end
