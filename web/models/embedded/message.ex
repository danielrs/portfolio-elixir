defmodule Portfolio.Message do
  use Portfolio.Web, :model

  embedded_schema do
    field :name, :string
    field :email, :string
    field :subject, :string
    field :text, :string
  end

  @required_fields [:name, :email, :subject, :text]
  @optional_fields []

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
  end
end
