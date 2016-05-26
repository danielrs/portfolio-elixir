defmodule Portfolio.User do
  use Portfolio.Web, :model
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  @derive {Poison.Encoder, only: [:id, :first_name, :last_name, :email]}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    belongs_to :role, Portfolio.Role
    has_many :projects, Portfolio.Project
    has_many :posts, Portfolio.Post

    timestamps
  end

  @required_fields ~w(first_name last_name email password password_confirmation role_id)
  @optional_fields ~w(password_hash)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password, message: "Password does not match")
    |> encrypt_password
    |> unique_constraint(:email, message: "already taken")
  end

  def encrypt_password(changeset) do
    if changeset.valid? do
      changeset
      |> put_change(:password_hash, get_change(changeset, :password) |> hashpwsalt)
    else
      changeset
    end
  end

  # def encrypt_password(%) do
  #   if changeset.valid? do
  #     changeset
  #     |> put_change(:password_hash, get_change(changeset, :password) |> hashpwsalt)
  #   else
  #     changeset
  #   end
  # end

end
