defmodule Portfolio.Message do
  use Portfolio.Web, :model

  schema "message" do
    field :name, :string
    field :email, :string
    field :subject, :string
    field :body, :string
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name email subject body), ~w())
    |> validate_format(:email, ~r/@/)
  end
end
