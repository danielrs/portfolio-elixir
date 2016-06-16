defmodule Portfolio.Filtrable do
  @callback filter_by(Ecto.Queryable.t, Plug.Conn.params) :: Ecto.Queryable.t
  @callback search_by(Ecto.Queryable.t, String.t) :: Ecto.Queryable.t
  @callback order_by(Ecto.Queryable.t, %{Atom => String.t}) :: Ecto.Queryable.t

  defmacro __using__(_opts) do
    quote do
      import Portfolio.Filtrable
      require Portfolio.Filtrable
      @behaviour Portfolio.Filtrable
    end
  end

  defmacro deffilter(filtrable_fields, body) do
    quote do
      def filter_by(query, params) do
        search_string = "%" <> Map.get(params, "search", "") <> "%"
        order_map = Portfolio.Utils.OrderBy.from_string(
          Map.get(params, "order_by", Enum.join(unquote(filtrable_fields), ",")),
          unquote(filtrable_fields)
        )
        query
        |> search_by(search_string)
        |> order_by(order_map)
      end

      unquote(body)

      def search_by(query, _search_string), do: query
      def order_by(query, _order_map), do: query
    end
  end
end
