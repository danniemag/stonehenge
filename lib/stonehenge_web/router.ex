defmodule StonehengeWeb.Router do
  use StonehengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  scope "/api", StonehengeWeb do
    pipe_through :api
    post "/users/sign_in", UserController, :sign_in
  end

  scope "/api", StonehengeWeb do
    pipe_through [:api, :api_auth]
    get "/users/balance/", UserController, :balance
    resources "/users", UserController, except: [:new, :edit]
    post "/users/withdrawal", UserController, :withdrawal
  end

  defp ensure_authenticated(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> render(StonehengeWeb.ErrorView, "401.json", message: "Unauthenticated user")
      |> halt()
    end
  end
end
