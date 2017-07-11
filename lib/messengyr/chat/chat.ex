defmodule Messengyr.Chat do

  alias Messengyr.Chat.{Message, Room, RoomUser}
  alias Messengyr.Accounts.User
  alias Messengyr.Repo

  import Ecto.Query

  def list_user_rooms(user) do
    # Build the Ecto query:
    query = from r in Room,
      join: u in assoc(r, :users),
      where: u.id == ^user.id

    # Use the query:
    Repo.all(query)
    |> preload_room_data
  end

  def create_room() do
    room = %Room{}
    Repo.insert(room)
  end

  def add_room_user(room, user) do
    room_user = %RoomUser{
      room: room,
      user: user
    }
    Repo.insert(room_user)
  end

  def add_message(%{room: room, user: user, text: text}) do
    message = %Message{
      room: room,
      user: user,
      text: text
    }
    Repo.insert(message)
  end

  def list_rooms do
    Repo.all(Room)
    |> preload_room_data
  end

  def create_room_with_counterpart(me, counterpart_username) do
    counterpart = Repo.get_by!(User, username: counterpart_username)
    members = [counterpart, me]

    with {:ok, room } <- create_room() do
      add_room_users(room, members)
    end
  end

  def get_room(id) do
    Repo.get(Room, id)
  end

  def room_has_user?(room, user) do
    # Find a row in the "room_users" table that contains
    # the given room and user
    query = from ru in RoomUser,
      where: ru.room_id == ^room.id and ru.user_id == ^user.id

    # If a room was found, return true!
    case Repo.one(query) do
      %RoomUser{} -> true
      _ -> false
    end
  end

  def get_message(id) do
    Repo.get(Message, id)
    |> Repo.preload(:room)
  end

  defp preload_room_data(room) do
    room
    |> Repo.preload(:messages)
    |> Repo.preload(:users)
  end

  defp add_room_users(room, []) do
    {:ok, room |> preload_room_data}
  end

  defp add_room_users(room, [first_user | other_users]) do
    # We add the first room_user to the database:
    case add_room_user(room, first_user) do
      {:ok, _} ->
        #... then we let the function call itself:
        add_room_users(room, other_users)
      _ ->
        {:error, "Failed to add user to room!"}
    end
  end

end
