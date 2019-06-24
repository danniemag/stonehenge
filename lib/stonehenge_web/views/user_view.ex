defmodule StonehengeWeb.UserView do
  use StonehengeWeb, :view
  alias StonehengeWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      is_active: user.is_active,
      balance: user.balance}
  end

  def render("sign_in.json", %{user: user}) do
    %{
      data: %{
        user: %{
          id: user.id,
          email: user.email
        }
      }
    }
  end

  def render("sign_out.json", %{message: message}) do
    %{
      message: message
    }
  end

  def render("balance.json", %{user: user}) do
    %{
      data: %{
        current_user_id: user.id,
        current_user_email: user.email,
        current_balance: user.balance,
      }
    }
  end

  def render("withdrawal.json", %{user: user}) do
    %{
      data: %{
        current_user_id: user.id,
        user_email: user.email,
        current_balance: user.balance,
      }
    }
  end

  def render("transfer.json", %{value: value, user: user, receiver: receiver}) do
    %{
      data: %{
        transferred_value: value,
        debit_account: user.email,
        destination_account: receiver.email,
        current_balance: user.balance,
      }
    }
  end
end
