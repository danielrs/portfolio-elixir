defmodule Portfolio.Guardian do
  @behaviour Guardian.Serializer

  alias Portfolio.Repo
  alias Portfolio.User

  require Ecto.Query
  import Ecto.Query, only: [from: 2]

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id) do
    query = from u in User,
      join: r in assoc(u, :role),
      preload: [role: r]
    {:ok, query |> Repo.get(id)}
  end

  def from_token(_), do: {:error, "Unknown resource type"}
end
