defmodule Portfolio.Project do
  use Portfolio.Web, :model
  alias Portfolio.Project

  @behaviour Portfolio.Filterable
  def fields, do: ~w(date title description homepage)

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

  def order_by(query \\ %Project{}, params) do
    case params.order do
      "desc" ->
        query |> Ecto.Query.order_by(desc: ^String.to_atom(params.sort_by))
      _ ->
        query |> Ecto.Query.order_by(asc: ^String.to_atom(params.sort_by))
    end
  end

  def search_by(query \\ %Project{}, params) do
    search_string = "%" <> params.search <> "%"
    from p in query,
    where: ilike(p.title, ^search_string) or ilike(p.description, ^search_string)
  end
end
