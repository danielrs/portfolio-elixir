defmodule Portfolio.Repo.Migrations.ProjectsTags do
  use Ecto.Migration

  def change do
    create table(:projects_tags) do
      add :project_id, references(:projects), null: false
      add :tag_id, references(:tags), null: false
    end
  end
end
