defmodule Portfolio.Filtrable do
  @callback search_by(Ecto.Queryable.t, Plug.Conn.params) :: Ecto.Queryable.t
  @callback order_by(Ecto.Queryable.t, Plug.Conn.params) :: Ecto.Queryable.t

  defmacro __using__(_opts) do
    quote do
      @behaviour Portfolio.Filtrable
      def filter_by(query, params) do
        query
        |> search_by(params)
        |> order_by(params)
      end
    end
  end
end
