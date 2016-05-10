defmodule Portfolio.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :string, null: false
      add :description, :string, null: false
      add :homepage, :string, null: false
      add :content, :text
      add :date, :date, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps
    end
    create index(:projects, [:user_id])
  end
end
