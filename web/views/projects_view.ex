defmodule Portfolio.ProjectsView do
  use Portfolio.Web, :view

  def project_list do
    [%{caption: "Portfolio website",
       url: "https://github.com/DanielRS/portfolio",
       description: "It makes use of Elixir and Phoenix framework; it contains CRUD actions for projects and blog posts."},

     %{caption: "Marquee",
       url: "https://github.com/DanielRS/marquee",
       description: "Markdown transpiler written in Haskell"},

     %{caption: "Typing.js",
       url: "https://github.com/DanielRS/typing.js",
       description: "jQuery plugin for typing animations"},

     %{caption: "dotfiles",
       url: "https://github.com/DanielRS/dotfiles",
       description: "A set of dotfiles for text-editors, window managers, and other tools"},

     %{caption: "DwarfEngine",
       url: "https://github.com/DanielRS/DwarfEngine",
       description: "Game engine written in C++"}]
  end

  def project_count do
    Enum.count(project_list)
  end
end
