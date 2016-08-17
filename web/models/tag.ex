defmodule Portfolio.Tag do
  use Portfolio.Web, :model

  schema "tags" do
    field :name, :string

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
    |> String.replace(~r/[^-\p{L}0-9]/u, "")
  end
end
