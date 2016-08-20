defmodule Portfolio.Paginator do
  defstruct [:entries, :page_number, :page_size, :total_pages]
  import Ecto.Query
  alias Portfolio.Paginator
  alias Portfolio.Repo

  def new(query, params) do
    page_number = params |> Map.get("page", 1) |> to_int
    page_size = params |> Map.get("page_size", 10) |> to_int

    %Paginator{
      entries: entries(query, page_number, page_size),
      page_number: page_number,
      page_size: page_size,
      total_pages: total_pages(query, page_size)
    }
  end

  defp entries(query, page_number, page_size) do
    offset = page_size * (page_number - 1)

    query
    |> limit(^page_size)
    |> offset(^offset)
    |> Repo.all
  end

  defp total_pages(query, page_size) do
    count = query
            |> exclude(:preload)
            |> exclude(:select)
            |> exclude(:order_by)
            |> select([row], count(row.id))
            |> Repo.one

    Float.ceil(count / page_size) |> trunc
  end

  defp to_int(x) when is_integer(x) do
    x
  end
  defp to_int(x) when is_binary(x) do
    case Integer.parse(x) do
      {x, _} -> x
      :error -> :error
    end
  end
end
