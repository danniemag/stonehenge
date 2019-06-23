use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stonehenge, StonehengeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :stonehenge, Stonehenge.Repo,
  username: "postgres",
  password: "postgres",
  database: "stonehenge_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Bcrypt config speed up process by easing security
config :bcrypt_elixir, :log_rounds, 4