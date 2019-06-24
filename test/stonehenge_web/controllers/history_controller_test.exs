defmodule StonehengeWeb.HistoryControllerTest do
  use StonehengeWeb.ConnCase

  alias Stonehenge.Backoffice
  alias Stonehenge.Backoffice.History

  @create_attrs %{
    destination_account: "some destination_account",
    operation_type: "some operation_type",
    origin_account: "some origin_account",
    value: 120.5
  }
  @update_attrs %{
    destination_account: "some updated destination_account",
    operation_type: "some updated operation_type",
    origin_account: "some updated origin_account",
    value: 456.7
  }
  @invalid_attrs %{destination_account: nil, operation_type: nil, origin_account: nil, value: nil}

  def fixture(:history) do
    {:ok, history} = Backoffice.create_history(@create_attrs)
    history
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all histories", %{conn: conn} do
      conn = get(conn, Routes.history_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create history" do
    test "renders history when data is valid", %{conn: conn} do
      conn = post(conn, Routes.history_path(conn, :create), history: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.history_path(conn, :show, id))

      assert %{
               "id" => id,
               "destination_account" => "some destination_account",
               "operation_type" => "some operation_type",
               "origin_account" => "some origin_account",
               "value" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.history_path(conn, :create), history: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update history" do
    setup [:create_history]

    test "renders history when data is valid", %{conn: conn, history: %History{id: id} = history} do
      conn = put(conn, Routes.history_path(conn, :update, history), history: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.history_path(conn, :show, id))

      assert %{
               "id" => id,
               "destination_account" => "some updated destination_account",
               "operation_type" => "some updated operation_type",
               "origin_account" => "some updated origin_account",
               "value" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, history: history} do
      conn = put(conn, Routes.history_path(conn, :update, history), history: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete history" do
    setup [:create_history]

    test "deletes chosen history", %{conn: conn, history: history} do
      conn = delete(conn, Routes.history_path(conn, :delete, history))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.history_path(conn, :show, history))
      end
    end
  end

  defp create_history(_) do
    history = fixture(:history)
    {:ok, history: history}
  end
end
