defmodule Portfolio.Repo.Migrations.AddLanguageFieldToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :language, :string, default: ""
    end
  end
end
