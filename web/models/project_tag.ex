defmodule Portfolio.ProjectTag do
  use Portfolio.Web, :model

  schema "projects_tags" do
    belongs_to :project, Portfolio.Project
    belongs_to :tag, Portfolio.Tag
  end
end
