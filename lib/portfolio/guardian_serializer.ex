defmodule Portfolio.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Portfolio.Repo
  alias Portfolio.User

  require Ecto.Query

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id), do: {:ok, User |> Ecto.Query.preload(:role) |> Repo.get(id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end
