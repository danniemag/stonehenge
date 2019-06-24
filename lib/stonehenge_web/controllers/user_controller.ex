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
    value = to_float(value)
    cond do
      user = Auth.get_user!(get_session(conn, :current_user_id)) ->
        cond do
          user.balance >= value -> {:ok, perform_withdrawal(conn, value, user)}
          true -> insufficient_balance(conn)
        end
    end

  end

  def transfer(conn, %{"email" => email, "value" => value}) do
    value = to_float(value)
    cond do
      receiver = Stonehenge.Repo.get_by(User, email: email) ->
        user = Auth.get_user!(get_session(conn, :current_user_id))
          cond do
            user.balance >= value -> {:ok, perform_transfer(conn, value, user, receiver)}
            true -> insufficient_balance(conn)
          end
      true -> receiver_not_found(conn)
    end
  end


  # ------- Helper methods | No routes
  def perform_withdrawal(conn, value, user) do
    user
      |> Ecto.Changeset.change(%{balance: user.balance - value})
      |> Stonehenge.Repo.update()
      generate_history_log("debit", (-value), user.email, nil)
      user = Auth.get_user!(user.id)
      render conn, "withdrawal.json", value: value, user: user
  end

  def perform_transfer(conn, value, user, receiver) do
    receiver
      |> Ecto.Changeset.change(%{balance: receiver.balance + value})
      |> Stonehenge.Repo.update()
    user
      |> Ecto.Changeset.change(%{balance: user.balance - value})
      |> Stonehenge.Repo.update()
      generate_history_log("debit", (-value), user.email, nil)
      generate_history_log("credit", value, user.email, receiver.email)
      user = Auth.get_user!(user.id)
      render conn, "transfer.json", value: value, user: user, receiver: receiver
  end

  def generate_history_log(operation_type, value, origin_account, destination_account) do
    Stonehenge.Repo.insert!(%Stonehenge.Backoffice.History{operation_type: operation_type, value: value, origin_account: origin_account, destination_account: destination_account})
  end

  def to_float(value) do
    value/1    
  end


  # ------ Exceptions | No routes
  def insufficient_balance(conn) do
    render conn, "exception.json", message: "Insufficient balance to perform this operation"
  end

  def receiver_not_found(conn) do
    render conn, "exception.json", message: "Destination account not found"
  end
end
