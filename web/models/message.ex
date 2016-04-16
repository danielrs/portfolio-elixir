defmodule Portfolio.Message do
  use Portfolio.Web, :model

  schema "message" do
    field :name, :string, virtual: true
    field :email, :string, virtual: true
    field :subject, :string, virtual: true
    field :body, :string, virtual: true
  end

  @required_fields ~w(name email subject body)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
  end
end
