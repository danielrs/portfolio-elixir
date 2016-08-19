defmodule HairlineTheme.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :hairline,
     version: @version,
     elixir: "~> 1.3",
     deps: deps(),

     name: "Portfolio.Theme.Hairline",
     description: "Portfolio.Themes.Hairline is the default theme of Portfolio",
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end

  defp package do
    [maintainers: ["Daniel Rivas"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/DanielRS/hairline-theme"},
     files: ~w(static templates) ++
            ~w(bower.json brunch-config.js LICENSE mix.exs package.json README.md)]
  end
end
