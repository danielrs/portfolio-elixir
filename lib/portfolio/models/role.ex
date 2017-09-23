defmodule Portfolio.Role do
  use PortfolioWeb, :model

  schema "roles" do
    field :name, :string
    field :admin?, :boolean, default: false
    has_many :users, Portfolio.User

    timestamps
  end

  @required_fields [:name, :admin?]
  @optional_fields []

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :%{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name, message: "already taken")
  end
end
