defmodule Stonehenge.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :balance, :float, default: 1000.0
    field :email, :string
    field :is_active, :boolean, default: false
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_active, :balance, :password])
    |> validate_required([:email, :is_active, :balance, :password])
    |> unique_constraint(:email)
  end
end
