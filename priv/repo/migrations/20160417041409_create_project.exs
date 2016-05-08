defmodule Portfolio.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def up do
    create table(:projects) do
      add :title, :string, null: false
      add :description, :string, null: false
      add :homepage, :string, null: false
      add :content, :text
      add :date, :date, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    alter table(:projects), do: modify :user_id, :integer, null: false
    create index(:projects, [:user_id])
  end

  def down do
    drop table(:projects)
  end
end
