defmodule StonehengeWeb.UserController do
  use StonehengeWeb, :controller

  alias Stonehenge.Auth
  alias Stonehenge.Auth.User

  action_fallback StonehengeWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Auth.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Stonehenge.Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_status(:ok)
        |> render(StonehengeWeb.UserView, "sign_in.json", user: user)

      {:error, message} ->
        conn
        |> delete_session(:current_user_id)
        |> put_status(:unauthorized)
        |> render(StonehengeWeb.ErrorView, "401.json", message: message)
    end
  end

  def sign_out(conn, _) do
    conn
    |> delete_session(:current_user_id)
    |> put_status(:ok)
    |> render(StonehengeWeb.UserView, "sign_out.json", message: "Successfully logged out")
  end

  def balance(conn, _params) do
    user = Auth.get_user!(get_session(conn, :current_user_id))
    render(conn, "balance.json", user: user)
  end

  def withdrawal(conn, %{"value" => value}) do
    cond do
      user = Auth.get_user!(get_session(conn, :current_user_id)) ->
        cond do
          user.balance >= value -> {:ok, perform_withdrawal(conn, value, user)}
        end
        insufficient_balance()
    end
    conn
      |> delete_session(:current_user_id)
      |> put_status(:unauthorized)
      |> render(StonehengeWeb.ErrorView, "401.json", message: "No user logged!")
  end


  # Helper methods - No routes
  def perform_withdrawal(conn, value, user) do
    user
      |> Ecto.Changeset.change(%{balance: user.balance - value})
      |> Stonehenge.Repo.update()
      user = Auth.get_user!(user.id)
      render conn, "withdrawal.json", value: value, user: user
  end

  def insufficient_balance() do
    render(StonehengeWeb.ErrorView, "203.json", message: "Insufficient balance to perform this operation.")
  end
end
