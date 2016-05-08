defmodule Portfolio.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def up do
    create table(:posts) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :markdown, :text, null: false
      add :html, :text, null: false
      add :date, :date, null: false
      add :published, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    alter table(:posts), do: modify :user_id, :integer, null: false
    create index(:posts, [:user_id])
    create unique_index(:posts, [:slug])
  end

  def down do
    drop table(:posts)
  end
end
