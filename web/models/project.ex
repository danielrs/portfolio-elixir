defmodule Portfolio.Project do
  use Portfolio.Web, :model
  use Portfolio.Filtrable
  require Logger

  schema "projects" do
    field :title, :string
    field :description, :string
    field :homepage, :string
    field :content, :string, default: ""
    field :date, Ecto.Date, default: Ecto.Date.utc
    belongs_to :user, Portfolio.User

    timestamps
  end

  @required_fields [:title, :description, :homepage, :date]
  @optional_fields [:content]
  @filtrable_fields [:date, :title, :description, :homepage]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> update_change(:date, &cast_date(&1))
  end

  deffilter @filtrable_fields do
    def search_by(query, search_string) do
      from p in query,
      where: ilike(p.title, ^search_string)
      or ilike(p.description, ^search_string)
      or ilike(p.homepage, ^search_string)
    end
    def order_by(query, order_map) do
      query |> Ecto.Query.order_by(^order_map)
    end
  end
end
