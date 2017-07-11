defmodule Messengyr.Web.ChatController do
  @moduledoc """
  The controller for the Messaging page,
  available only for logged-in users
  """
  
  use Messengyr.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    render conn
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "You need to log in to view your messages.")
    |> redirect(to: "/")
  end
end
