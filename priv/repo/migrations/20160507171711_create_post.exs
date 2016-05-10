defmodule Portfolio.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :markdown, :text, null: false
      add :html, :text, null: false
      add :date, :date, null: false
      add :published, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps
    end
    create index(:posts, [:user_id])
    create unique_index(:posts, [:slug])
  end
end
