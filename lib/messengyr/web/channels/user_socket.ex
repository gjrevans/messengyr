defmodule Messengyr.Web.UserSocket do
  use Phoenix.Socket
  import Messengyr.Accounts.GuardianSerializer, only: [from_token: 1]

  ## Channels
  channel "room:*", Messengyr.Web.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"guardianToken" => jwt}, socket) do

    # Decode the jtw and get the user associated with it:
    with {:ok, claims} <- Guardian.decode_and_verify(jwt),
         {:ok, user} <- from_token(claims["sub"])
    do
      # Assign the user to the socket!
      {:ok, assign(socket, :current_user, user)}
    else
      _ -> :error
    end
  end

  # If the user tries to connect without that the token parameter
  # it should return an :error instantly
  def connect(_params, _socket) do
    :error
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Messengyr.Web.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
