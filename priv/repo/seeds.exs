# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Stonehenge.Repo.insert!(%Stonehenge.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

password = "Rock2019*"

Stonehenge.Repo.insert!(
    %Stonehenge.Auth.User{
        email: "admin@stonehenge.com",
        password: password,
        password_hash: Bcrypt.hash_pwd_salt(password),
        balance: 0.0
})
