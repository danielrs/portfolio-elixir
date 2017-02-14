# Taken from: https://github.com/drewolson/scrivener_ecto/blob/master/lib/scrivener/paginater/ecto/query.ex

defmodule Portfolio.Paginator do
  defstruct [:page_number, :page_size, :entries, :total_entries, :total_pages]
  import Ecto.Query
  alias Portfolio.Paginator
  alias Portfolio.Repo

  def new(query, params) do
    page_number = params |> Map.get("page", 1) |> to_int |> positive
    page_size = params |> Map.get("page_size", 10) |> to_int |> positive

    total_entries = total_entries(query)

    %Paginator{
      page_number: page_number,
      page_size: page_size,
      entries: entries(query, page_number, page_size),
      total_entries: total_entries,
      total_pages: total_pages(total_entries, page_size)
    }
  end

  defp entries(query, page_number, page_size) do
    offset = page_size * (page_number - 1)

    query
    |> limit(^page_size)
    |> offset(^offset)
    |> Repo.all
  end

  defp total_entries(query) do
    total_entries =
      query
      |> exclude(:preload)
      |> exclude(:select)
      |> subquery
      |> select(count("*"))
      |> Repo.one

    total_entries || 0
  end

  defp total_pages(total_entries, page_size) do
    (total_entries / page_size) |> Float.ceil |> round
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

  defp positive(x) do
    x
  end
end
