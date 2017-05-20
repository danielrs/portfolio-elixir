defmodule Yaml do
  def read_url(url, timeout \\ 1000) do
    response = HTTPotion.get url, [timeout: timeout]
    if HTTPotion.Response.success?(response) do
      response.body |> read_string
    else
      {:error, response}
    end
  end

  def read_file(path) do
    try do
      {:ok, path |> YamlElixir.read_from_file}
    catch
      x -> {:error, x}
    end
  end

  def read_string(string) do
    try do
      {:ok, string |> YamlElixir.read_from_string}
    catch
      x -> {:error, x}
    end
  end
end
