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
  end
end
