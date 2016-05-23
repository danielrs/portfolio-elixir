defmodule Portfolio.Plug.Filter do
  import Plug.Conn

  alias Portfolio.Params.Filter
  alias Portfolio.Filterable

  def init(default), do: default

  def call(conn, model) do
    filter_params =
      Filter.changeset(%Filter{}, model.fields, conn.params)
      |> Ecto.Changeset.apply_changes
      |> Map.from_struct
    params = Map.merge(conn.params, filter_params)
    %{conn | params: params}
  end
end
