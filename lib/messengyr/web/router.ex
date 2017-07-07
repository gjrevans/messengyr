defmodule Messengyr.Web.Router do
  use Messengyr.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession # Check if the user is logged in
    plug Guardian.Plug.LoadResource # Check who is logged in
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Guardian.Plug.VerifySession # Check if the user is logged in
    plug Guardian.Plug.LoadResource # Check who is logged in
  end

  scope "/", Messengyr.Web do
    pipe_through [:browser, :browser_session]

    # Account Routes
    get "/", PageController, :index
    get "/signup", PageController, :signup
    get "/login", PageController, :login
    post "/signup", PageController, :create_user
    post "/login", PageController, :login_user
    get "/logout", PageController, :logout

    # Messaging Routes
    get "/messages", ChatController, :index
  end

  scope "/api", Messengyr.Web do
    pipe_through :api

    # User Routes
    resources "/users", UserController, only: [:show]

    # Room Routes
    resources "/rooms", RoomController
  end
end
