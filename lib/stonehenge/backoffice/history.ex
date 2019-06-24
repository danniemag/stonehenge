defmodule Stonehenge.Backoffice.History do
  use Ecto.Schema
  import Ecto.Changeset

  schema "histories" do
    field :destination_account, :string
    field :operation_type, :string
    field :origin_account, :string
    field :value, :float

    timestamps()
  end

  @doc false
  def changeset(history, attrs) do
    history
    |> cast(attrs, [:operation_type, :value, :origin_account, :destination_account])
    |> validate_required([:operation_type, :value, :origin_account, :destination_account])
  end
end
