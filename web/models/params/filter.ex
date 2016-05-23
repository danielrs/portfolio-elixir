defmodule Portfolio.Params.Filter do
  use Portfolio.Web, :model

  @order ~w(desc asc)

  schema "filter" do
    field :sort_by, :string, default: "", virtual: true
    field :order, :string, default: "desc", virtual: true
    field :search, :string, default: "", virtual: true
  end

  @required_fields ~w()
  @optional_fields ~w(sort_by order search)

  def changeset(model, sort_fields, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_sort(sort_fields)
    |> cast_order
    |> cast_search
  end

  def cast_sort(changeset, sort_fields) do
    sort_by = get_change(changeset, :sort_by)
    if sort_by && contains(sort_fields, sort_by) do
      changeset
    else
      put_change(changeset, :sort_by, hd sort_fields)
    end
  end

  def cast_order(changeset) do
    order = get_change(changeset, :order)
    if order && contains(@order, order) do
      changeset
    else
      put_change(changeset, :order, hd @order)
    end
  end

  def cast_search(changeset) do
    search = get_change(changeset, :search)
    if search do
      changeset
    else
      put_change(changeset, :search, "")
    end
  end

  defp contains(array, x) do
    Enum.any?(array, &(&1 == x))
  end
end
