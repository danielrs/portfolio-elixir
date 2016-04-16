defmodule Portfolio.Login do
  use Portfolio.Web, :model

  import Comeonin.Bcrypt, only: [hashpwsalt: 1, checkpw: 2]
  import Ecto.Query, only: [from: 2]

  alias Portfolio.User
  alias Portfolio.Repo

  schema "login" do
    field :email, :string, virtual: true
    field :password, :string, virtual: true
    field :request_path, :string, virtual: true
  end

  @required_fields ~w(email password)
  @optional_fields ~w(request_path)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase(&1))
  end

  def confirm_credentials(changeset) do
    if changeset.valid? do
      email = get_change(changeset, :email)
      password = get_change(changeset, :password)
      user = Repo.get_by(User, email: String.downcase(email))
      if user && checkpw(password, user.password_hash) do
        {:ok, user}
      else
        {:error, changeset |> add_error(:email, "invalid credentials")}
      end
    else
      {:error, changeset}
    end
  end
end
