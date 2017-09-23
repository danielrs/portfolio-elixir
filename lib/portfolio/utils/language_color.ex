defmodule Portfolio.LanguageColor do
  alias Portfolio.Utils

  @cache_key :language_colors
  @url "https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml"

  # from: https://material.io/guidelines/style/color.html
  @fallback_colors [
    "#EF5350", # Red 400
    "#EC407A", # Pink 400
    "#AB47BC", # Purple 400
    "#7E57C2", # Deep Purple 400
    "#5C6BC0", # Indigo 400
    "#42A5F5", # Blue 400
    "#66BB6A", # Green 400
    "#FF7043", # Deep Orange 400
    "#8D6E63", # Brown 400
    "#78909C", # Blue Grey 400
  ]

  def get(language) do
    case Cachex.get(:cache, @cache_key) do
      {:ok, cached} ->
        Map.get(cached, language |> String.downcase) || fallback(language)
      {:missing, _} ->
        case Yaml.read_url(@url) do
          {:ok, parsed} ->
            Cachex.set(:cache, @cache_key, parsed |> map_colors)
            get(language)
          {:error, _} ->
            fallback(language)
        end
    end
  end

  defp fallback(language) do
    @fallback_colors
    |> Enum.at(Utils.codify(language |> String.downcase) |> rem(10))

  end

  defp map_colors(map) do
    map
    |> Enum.map(fn {k, v} ->
      if Map.has_key?(v, "color") do
        {k |> String.downcase, v["color"]}
      else
        {k, nil}
      end
    end)
    |> Enum.filter(fn {_, v} -> v end)
    |> Enum.into(%{})
  end
end
