defmodule StonehengeWeb.Router do
  use StonehengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", StonehengeWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    post "/users/sign_in", UserController, :sign_in
  end
end
