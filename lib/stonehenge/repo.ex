defmodule Stonehenge.Repo do
  use Ecto.Repo,
    otp_app: :stonehenge,
    adapter: Ecto.Adapters.Postgres
end
