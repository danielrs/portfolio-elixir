defmodule Portfolio.Session do
  use Portfolio.Web, :model

  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias Portfolio.User
  alias Portfolio.Repo

  schema "session" do
    field :email, :string, virtual: true
    field :password, :string, virtual: true
  end

  @required_fields [:email, :password]
  @optional_fields []

  def changeset(model, params \\ :%{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
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
