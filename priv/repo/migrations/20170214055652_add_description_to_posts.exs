defmodule Portfolio.Repo.Migrations.AddDescriptionToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :description, :string, default: ""
    end
  end
end
