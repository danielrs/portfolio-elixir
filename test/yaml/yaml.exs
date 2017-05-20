defmodule YamlTest do
  use ExUnit.Case

  @valid_yaml """
  a: one
  b: 2
  c: true
  d: ~
  e: nil
  """

  @invalid_yaml """
  a=s
  b: 2
  c= true
  """

  @valid_url "https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml"
  @invalid_url "https://raw.githubusercontent.com/github/linguist/master/lib/linguist/lamguajez.yml"

  test "Parses valid yaml" do
    case Yaml.read_string(@valid_yaml) do
      {:ok, parsed} -> assert Enum.count(parsed) == 5
      {:error, error} -> flunk(error)
    end
  end

  test "Errors on invalid yaml" do
    case Yaml.read_string(@invalid_yaml) do
      {:ok, _} -> flunk("Parsed invalid yaml")
      {:error, _} -> assert true
    end
  end

  test "Parses valid url" do
    case Yaml.read_url(@valid_url) do
      {:ok, _} -> assert true
      {:error, error} -> flunk(error)
    end
  end

  test "Errors on invalid url" do
    case Yaml.read_url(@invalid_url) do
      {:ok, _} -> flunk("Parsed invalid yaml at url")
      {:error, _} -> assert true
    end
  end
end
