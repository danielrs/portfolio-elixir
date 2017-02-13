defmodule Portfolio.Repo.Migrations.AddOnDeletePostsTags do
  use Ecto.Migration

  def up do
	execute "ALTER TABLE posts_tags DROP CONSTRAINT posts_tags_post_id_fkey"
    execute "ALTER TABLE posts_tags DROP CONSTRAINT posts_tags_tag_id_fkey"
	alter table(:posts_tags) do
      modify :post_id, references(:posts, null: false, on_delete: :delete_all)
      modify :tag_id, references(:tags, null: false, on_delete: :delete_all)
	end
  end

  def down do
	execute "ALTER TABLE posts_tags DROP CONSTRAINT posts_tags_post_id_fkey"
    execute "ALTER TABLE posts_tags DROP CONSTRAINT posts_tags_tag_id_fkey"
	alter table(:posts_tags) do
      modify :post_id, references(:posts, null: false, on_delete: :nothing)
      modify :tag_id, references(:tags, null: false, on_delete: :nothing)
	end
  end
end
