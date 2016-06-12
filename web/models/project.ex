defmodule Portfolio.Project do
  use Portfolio.Web, :model
  use Portfolio.Filtrable
  alias Portfolio.Project

  schema "projects" do
    field :title, :string
    field :description, :string
    field :homepage, :string
    field :content, :string, default: ""
    field :date, Ecto.Date, default: Ecto.Date.utc
    belongs_to :user, Portfolio.User

    timestamps
  end

  @required_fields ~w(title description homepage date)
  @optional_fields ~w(content)
  @filtrable_fields ~w(title description homepage date)

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

  def search_by(query, params) do
    search_string = "%" <> Map.get(params, "search", "") <> "%"
    from p in query,
    where: ilike(p.title, ^search_string) or ilike(p.description, ^search_string)
  end

  def order_by(query, params) do
    order_by = Portfolio.Utils.OrderBy.from_string(Map.get(params, "order_by", "-date"), @filtrable_fields)
    query |> Ecto.Query.order_by(^order_by)
  end
end
