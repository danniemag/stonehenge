defmodule StonehengeWeb.Router do
  use StonehengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", StonehengeWeb do
    pipe_through :api
  end
end
