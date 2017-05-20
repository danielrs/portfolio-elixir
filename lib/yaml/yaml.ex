defmodule Yaml do
  def read_url(url, timeout \\ 100) do
  end

  def read_file(path) do
    path |> YamlElixir.read_from_file
  end

  def read_string(string) do
    string |> YamlElixir.read_from_string
  end
end
