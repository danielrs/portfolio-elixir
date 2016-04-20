defmodule Portfolio.Project do
  use Portfolio.Web, :model

  schema "projects" do
    field :title, :string
    field :description, :string
    field :homepage, :string
    field :content, :string
    field :date, Ecto.Date, default: Ecto.Date.utc
    belongs_to :user, Portfolio.User

    timestamps
  end

  @required_fields ~w(title description homepage date)
  @optional_fields ~w(content)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:date, &cast_date(&1))
  end

  def cast_date(date) do
    case Ecto.Date.cast(date) do
      {:ok, new_date} -> new_date
      _ -> date
    end
  end
end
