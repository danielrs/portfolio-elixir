defmodule Portfolio.API.V1.ProjectView do
  use Portfolio.Web, :view

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, API.V1.ProjectView, "project.json", ignore: :content)}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, API.V1.ProjectView, "project.json")}
  end

  def render("project.json", %{project: project} = params) do
    ignores = Map.get(params, :ignore) |> List.wrap
    %{id: project.id,
      title: project.title,
      description: project.description,
      homepage: project.homepage,
      content: project.content,
      date: project.date,
      user_id: project.user_id}
    |> Map.drop(ignores)
  end
end
