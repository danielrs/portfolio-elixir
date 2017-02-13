defmodule Portfolio.Repo.Migrations.CreateProjectsTags do
  use Ecto.Migration

  def change do
    create table(:projects_tags) do
      add :project_id, references(:projects), null: false
      add :tag_id, references(:tags), null: false
    end
    create unique_index(:projects_tags, [:project_id, :tag_id])
  end
end
