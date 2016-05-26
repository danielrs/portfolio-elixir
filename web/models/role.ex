defmodule Portfolio.Role do
  use Portfolio.Web, :model

  schema "roles" do
    field :name, :string
    field :admin?, :boolean, default: false
    has_many :users, Portfolio.User

    timestamps
  end

  @required_fields ~w(name admin?)
  @optional_fields ~w()

  @valid_names ~w(admin user)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_name
    |> unique_constraint(:name, message: "already taken")
  end

  defp validate_name(changeset) do
    if Portfolio.Utils.oneOf(@valid_names, get_change(changeset, :name)) do
      changeset
    else
      changeset |> add_error(:name, "is not valid, must be one of: " <> Enum.join(@valid_names, ", "))
    end
  end
end
