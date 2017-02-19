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
    |> String.replace(~r/\s+/, "-")
    |> String.replace(~r/[^-\p{L}0-9]/u, "")
    |> String.replace(~r/-+/, "-")
  end

  #
  # Queries
  #

  # def tags_with_date do
  #   query = """
  #   SELECT *
  #   FROM (
  #     SELECT
  #       t.*,
  #       p.date date,
  #       row_number() OVER (
  #         PARTITION BY t.name ORDER BY p.date DESC
  #       ) rn
  #     FROM #{Portfolio.Tag.__schema__(:source)} as t
  #     INNER JOIN #{Portfolio.PostTag.__schema__(:source)} as pt
  #     ON pt.tag_id = t.id
  #     INNER JOIN #{Portfolio.Post.__schema__(:source)} as p
  #     ON p.id = pt.post_id
  #     ORDER BY t.name ASC
  #   ) as q
  #   WHERE q.rn <= 1;
  #   """

  #   Logger.debug query

  #   res = Ecto.Adapters.SQL.query!(Portfolio.Repo, query)
  #   cols = Enum.map res.columns, &(String.to_atom(&1))
  #   Enum.map res.rows, fn(row) ->
  #     Enum.zip(cols, row)
  #   end
  # end
end
