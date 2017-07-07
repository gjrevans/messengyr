defmodule Messengyr.Web.RoomController do
  use Messengyr.Web, :controller

  # we do this so we can access the model logic
  alias Messengyr.Chat

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    rooms = Chat.list_rooms()

    render(conn, "index.json", %{
      rooms: rooms,
      me: user
      })
  end
end
