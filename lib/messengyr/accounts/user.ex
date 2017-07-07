defmodule Messengyr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Messengyr.Accounts.User


  schema "users" do
    field :email, :string, unique: true
    field :username, :string, unique: true
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :encrypted_password])
    |> validate_required([:username, :email, :encrypted_password])
  end
end
