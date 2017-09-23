defmodule Portfolio.TagUpdater do
  alias Ecto.Changeset

  alias Portfolio.Repo
  alias Portfolio.Tag

  # Check: http://blog.plataformatec.com.br/2016/12/many-to-many-and-upserts/
  # TODO: Update to upserts after updating to ecto >= 2.1
  @spec put_tags(Ecto.Changeset.t, [String.t]) :: Ecto.Changeset.t
  def put_tags(changeset, tag_names) do
    if changeset.valid? do
      tags =
        (tag_names || [])
        |> List.wrap
        |> Enum.map(& Tag.changeset(%Tag{}, %{name: &1}))
        |> Enum.filter(& &1.valid?)
        |> Enum.uniq
        |> Enum.map(&get_or_insert_tag/1)

      changeset |> Changeset.put_assoc(:tags, tags)
    else
      changeset
    end
  end

  @spec get_or_insert_tag(Ecto.Changeset.t) :: any
  defp get_or_insert_tag(tag) do
    Repo.get_by(Tag, name: tag.changes.name) || maybe_insert_tag(tag)
  end

  @spec maybe_insert_tag(Ecto.Changeset.t) :: any
  defp maybe_insert_tag(tag) do
    tag
    |> Repo.insert
    |> case do
      {:ok, tag} -> tag
      {:error, _} -> Repo.get_by!(Tag, name: tag.changes.name)
    end
  end

  # def update(schema, struct, tag_names) do
  #   # Validates tags
  #   fields = Tag.__schema__(:fields) -- [:id]
  #   tags =
  #     tag_names
  #     |> Enum.map(fn name -> Tag.changeset(%Tag{}, %{name: name}) end)
  #     |> Enum.filter(fn tag -> tag.valid? end)

  #   # Executes the operations on the database
  #   Multi.new
  #   |> Multi.run(:tags, fn _changes ->
  #     Enum.map(tags, fn tag ->
  #       tag
  #       |> Repo.insert
  #       |> case do
  #         {:ok, tag} -> tag
  #         {:error, _} -> Repo.get_by!(Tag, name: tag.name)
  #       end
  #     end)
  #     {:ok, nil}
  #   end)
  #   |> Multi.run(:new_tags, fn _changes ->
  #     struct
  #     |> Repo.preload(:tags)
  #     |> Changeset.change
  #     |> Changeset.put_assoc(:tags, tags)
  #     |> Repo.update
  #   end)
  #   |> Repo.transaction
  # end
end
