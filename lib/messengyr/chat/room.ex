defmodule Messengyr.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Messengyr.Chat.Room
  alias Messengyr.Chat.Message
  alias Messengyr.Accounts.User

  schema "rooms" do
    has_many :messages, Message
    many_to_many :users, User, join_through: "room_users"
    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [])
    |> validate_required([])
  end
end
