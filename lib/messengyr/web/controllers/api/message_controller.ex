defmodule Messengyr.Web.MessageController do
  use Messengyr.Web, :controller

  alias Messengyr.Chat
  alias Messengyr.Chat.Message

  # We use our fallback controller to handle "nil" and ":not_allowed"
  action_fallback Messengyr.Web.FallbackController

  def show(conn, %{"id" => message_id}) do
    # Get the logged-in user:
    me = Guardian.Plug.current_resource(conn)

    # Get the message
    case Chat.get_message(message_id) do

      %Message{room: room} = message ->

        # Make sure that the user is allowed to see the message:
        if Chat.room_has_user?(room, me) do
          render(conn, "show.json", %{message: message, me: me})
        else
          :not_allowed
        end

      _ -> nil

    end
  end
end
