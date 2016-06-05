defmodule Portfolio.Plug.StripParams do

  @spec strip_params(Plug.Conn.t, String.t) :: Plug.Conn.t
  def strip_params(conn, required_key) when is_binary(required_key) do
    param = Map.get(conn.params, required_key) |> strip_param()

    unless param do
      raise Phoenix.MissingParamError, key: required_key
    end

    params = Map.put(conn.params, required_key, param)
    %{conn | params: params}
  end

  defp strip_param(%{__struct__: mod} = struct) when is_atom(mod) do
    struct
  end
  defp strip_param(%{} = param) do
    Enum.reduce(param, %{}, fn({k, v}, acc) ->
      new_v = strip_param(v)
      if new_v, do: Map.put(acc, k, new_v), else: acc
    end)
  end
  defp strip_param(param) when is_list(param) do
    Enum.map(param, &strip_param/1)
  end
  defp strip_param(param) do
    if scrub?(param), do: nil, else: param
  end

  defp scrub?(" " <> rest), do: scrub?(rest)
  defp scrub?(""), do: true
  defp scrub?(_), do: false
end
