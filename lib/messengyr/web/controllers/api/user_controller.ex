defmodule Messengyr.Web.UserController do
  use Messengyr.Web, :controller

  # we do this so we can access the model logic
  alias Messengyr.Accounts

  action_fallback Messengyr.Web.FallbackController

  def show(conn, %{"id" => user_id}) do
    user = Accounts.get_user(user_id)

    if user do
      render(conn, "show.json", user: user)
    end
  end

end
