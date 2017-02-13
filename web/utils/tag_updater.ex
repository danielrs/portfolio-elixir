defmodule Portfolio.TagUpdater do
  alias Ecto.Multi
  alias Ecto.Changeset

  alias Portfolio.Repo

  alias Portfolio.Post
  alias Portfolio.Tag
  alias Portfolio.PostTag

  import Ecto
  import Ecto.Query

  def update(schema, struct, tag_names) do
    # Validates tags
    fields = Tag.__schema__(:fields) -- [:id]
    tags =
      tag_names
      |> Enum.map(fn name -> Tag.changeset(%Tag{}, %{name: name}) end)
      |> Enum.filter(fn tag -> tag.valid? end)

    # Executes the operations on the database
    Multi.new
    |> Multi.run(:tags, fn _changes ->
      Enum.map(tags, fn tag ->
        tag
        |> Repo.insert
        |> case do
          {:ok, tag} -> tag
          {:error, _} -> Repo.get_by!(Tag, name: tag.name)
        end
      end)
      {:ok, nil}
    end)
    |> Multi.run(:new_tags, fn _changes ->
      struct
      |> Repo.preload(:tags)
      |> Changeset.change
      |> Changeset.put_assoc(:tags, tags)
      |> Repo.update
    end)
    |> Repo.transaction
  end

  # def update(schema, struct, tag_names) do
  #   # Validates tags
  #   fields = Tag.__schema__(:fields) -- [:id]
  #   timestamps = %{inserted_at: Ecto.DateTime.utc, updated_at: Ecto.DateTime.utc}
  #   tags =
  #     tag_names
  #     |> Enum.map(fn name -> Tag.changeset(%Tag{}, %{name: name}) end)
  #     |> Enum.filter(fn tag -> tag.valid? end)
  #     |> Enum.map(fn tag ->
  #       tag
  #       |> Changeset.apply_changes
  #       |> Map.from_struct
  #       |> Map.take(fields)
  #       |> Map.merge(timestamps)
  #     end)

  #   # Executes the operations on the database
  #   Multi.new
  #   |> Multi.insert_all(:tags, Tag, tags, on_conflict: :nothing)
  #   |> Multi.delete_all(:deleted_tags, assoc(struct, :tags))
  #   |> Multi.run(:new_tags, fn changes ->
  #     tag_names = tags |> Enum.map(fn tag -> tag.name end)
  #     tags = (from t in Tag, where: t.name in ^tag_names) |> Repo.all

  #     Repo.get(schema, struct.id)
  #     |> Repo.preload(:tags)
  #     |> Changeset.change
  #     |> Changeset.put_assoc(:tags, tags)
  #     |> Repo.update
  #   end)
  #   |> Repo.transaction
  # end
end
