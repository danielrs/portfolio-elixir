# Check
# http://tagging.pui.ch/post/37027745720/tags-database-schemas

defmodule Portfolio.Tag do
  use Portfolio.Web, :model

  schema "tags" do
    field :name, :string

    many_to_many :projects, Portfolio.Project,
      join_through: Portfolio.ProjectTag,
      on_delete: :delete_all,
      on_replace: :delete

    many_to_many :posts, Portfolio.Post,
      join_through: Portfolio.PostTag,
      on_delete: :delete_all,
      on_replace: :delete

    timestamps()
  end

  @required_fields [:name]
  @optional_fields []

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_name
    |> unique_constraint(:name)
  end

  defp cast_name(changeset) do
    if changeset.valid? do
      changeset |> update_change(:name, &tagify(&1))
    else
      changeset
    end
  end

  defp tagify(string) when is_binary(string) do
    string
    |> String.downcase
    |> String.replace(~r/\s/, "-")
    |> String.replace(~r/[^-+\p{L}0-9]/u, "")
  end

  #
  # Queries
  #

  @spec query_list([atom]) :: Ecto.Queryable.t
  def query_list(tag_names \\ []) do
    from t in Portfolio.Tag,
      where: t.name in ^tag_names
  end
end
