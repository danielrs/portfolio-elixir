defmodule Portfolio.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :string, null: false
      add :description, :string, null: false
      add :homepage, :string, null: false
      add :content, :text, null: false
      add :date, :date, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:projects, [:user_id])
    alter table(:projects) do
      modify :user_id, :integer, null: false
    end
  end
end
