defmodule Stonehenge.Repo.Migrations.CreateHistories do
  use Ecto.Migration

  def change do
    create table(:histories) do
      add :operation_type, :string, null: false
      add :value, :float, null: false
      add :origin_account, :string, null: false
      add :destination_account, :string

      timestamps()
    end

  end
end
