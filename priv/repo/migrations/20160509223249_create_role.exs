defmodule Portfolio.Repo.Migrations.CreateRole do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false
      add :admin?, :boolean, default: false

      timestamps
    end
    create unique_index(:roles, [:name])
  end
end
