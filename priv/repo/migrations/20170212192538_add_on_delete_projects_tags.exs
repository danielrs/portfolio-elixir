defmodule Portfolio.Repo.Migrations.AddOnDeleteProjectsTags do
  use Ecto.Migration

  def up do
	execute "ALTER TABLE projects_tags DROP CONSTRAINT projects_tags_project_id_fkey"
    execute "ALTER TABLE projects_tags DROP CONSTRAINT projects_tags_tag_id_fkey"
	alter table(:projects_tags) do
      modify :project_id, references(:projects, null: false, on_delete: :delete_all)
      modify :tag_id, references(:tags, null: false, on_delete: :delete_all)
	end
  end

  def down do
	execute "ALTER TABLE projects_tags DROP CONSTRAINT projects_tags_project_id_fkey"
    execute "ALTER TABLE projects_tags DROP CONSTRAINT projects_tags_tag_id_fkey"
	alter table(:projects_tags) do
      modify :project_id, references(:projects, null: false, on_delete: :nothing)
      modify :tag_id, references(:tags, null: false, on_delete: :nothing)
	end
  end
end
