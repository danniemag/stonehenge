defmodule Stonehenge.BackofficeTest do
  use Stonehenge.DataCase

  alias Stonehenge.Backoffice

  describe "histories" do
    alias Stonehenge.Backoffice.History

    @valid_attrs %{destination_account: "some destination_account", operation_type: "some operation_type", origin_account: "some origin_account", value: 120.5}
    @update_attrs %{destination_account: "some updated destination_account", operation_type: "some updated operation_type", origin_account: "some updated origin_account", value: 456.7}
    @invalid_attrs %{destination_account: nil, operation_type: nil, origin_account: nil, value: nil}

    def history_fixture(attrs \\ %{}) do
      {:ok, history} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Backoffice.create_history()

      history
    end

    test "list_histories/0 returns all histories" do
      history = history_fixture()
      assert Backoffice.list_histories() == [history]
    end

    test "get_history!/1 returns the history with given id" do
      history = history_fixture()
      assert Backoffice.get_history!(history.id) == history
    end

    test "create_history/1 with valid data creates a history" do
      assert {:ok, %History{} = history} = Backoffice.create_history(@valid_attrs)
      assert history.destination_account == "some destination_account"
      assert history.operation_type == "some operation_type"
      assert history.origin_account == "some origin_account"
      assert history.value == 120.5
    end

    test "create_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Backoffice.create_history(@invalid_attrs)
    end

    test "update_history/2 with valid data updates the history" do
      history = history_fixture()
      assert {:ok, %History{} = history} = Backoffice.update_history(history, @update_attrs)
      assert history.destination_account == "some updated destination_account"
      assert history.operation_type == "some updated operation_type"
      assert history.origin_account == "some updated origin_account"
      assert history.value == 456.7
    end

    test "update_history/2 with invalid data returns error changeset" do
      history = history_fixture()
      assert {:error, %Ecto.Changeset{}} = Backoffice.update_history(history, @invalid_attrs)
      assert history == Backoffice.get_history!(history.id)
    end

    test "delete_history/1 deletes the history" do
      history = history_fixture()
      assert {:ok, %History{}} = Backoffice.delete_history(history)
      assert_raise Ecto.NoResultsError, fn -> Backoffice.get_history!(history.id) end
    end

    test "change_history/1 returns a history changeset" do
      history = history_fixture()
      assert %Ecto.Changeset{} = Backoffice.change_history(history)
    end
  end
end
