defmodule Agitate.User do
  use Agitate.Web, :model

  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :applications, Agitate.Application
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_length(:email, min: 3, max: 255)
    |> validate_format(:email, ~r/@/)
    |> hash_password
  end

  defp hash_password(%{ valid?: true, changes: %{ password: password } } = changeset) do
    put_change changeset, :password_hash, Bcrypt.hashpwsalt(password)
  end

  defp hash_password(changeset) do
    changeset
  end
end
