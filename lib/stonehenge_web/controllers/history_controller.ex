defmodule StonehengeWeb.HistoryController do
  use StonehengeWeb, :controller

  alias Stonehenge.Backoffice
  alias Stonehenge.Backoffice.History

  action_fallback StonehengeWeb.FallbackController

  def index(conn, _params) do
    ensure_backoffice_security(conn)
    histories = Backoffice.list_histories()
    render(conn, "index.json", histories: histories)
  end

  def backoffice(conn, _params) do
    ensure_backoffice_security(conn)

    import Ecto.Query

    today = DateTime.utc_now()

    query = from h in History, select: sum(h.value), where: h.inserted_at >= ^Timex.beginning_of_day(today), where: h.inserted_at <= ^Timex.end_of_day(today), where: h.operation_type == "credit"
    credit_sum_current_day = Stonehenge.Repo.all(query)

    query = from h in History, select: sum(h.value), where: h.inserted_at >= ^Timex.beginning_of_day(today), where: h.inserted_at <= ^Timex.end_of_day(today), where: h.operation_type == "debit"
    debit_sum_current_day = Stonehenge.Repo.all(query)

    query = from h in History, select: sum(h.value), where: h.inserted_at >= ^Timex.beginning_of_month(today), where: h.inserted_at <= ^Timex.end_of_month(today), where: h.operation_type == "credit"
    credit_sum_current_month = Stonehenge.Repo.all(query)

    query = from h in History, select: sum(h.value), where: h.inserted_at >= ^Timex.beginning_of_month(today), where: h.inserted_at <= ^Timex.end_of_month(today), where: h.operation_type == "debit"
    debit_sum_current_month = Stonehenge.Repo.all(query)

    query = from h in History, select: sum(h.value), where: h.inserted_at >= ^Timex.beginning_of_year(today), where: h.inserted_at <= ^Timex.end_of_year(today), where: h.operation_type == "credit"
    credit_sum_current_year = Stonehenge.Repo.all(query)

    query = from h in History, select: sum(h.value), where: h.inserted_at >= ^Timex.beginning_of_year(today), where: h.inserted_at <= ^Timex.end_of_year(today), where: h.operation_type == "debit"
    debit_sum_current_year = Stonehenge.Repo.all(query)

    render(conn, "backoffice.json", credit_sum: credit_sum_current_day,
                                    debit_sum_current_day: debit_sum_current_day, 
                                    credit_sum_current_month: credit_sum_current_month, 
                                    debit_sum_current_month: debit_sum_current_month, 
                                    credit_sum_current_year: credit_sum_current_year, 
                                    debit_sum_current_year: debit_sum_current_year)
  end


  # ------- Helper methods | No routes
  def ensure_backoffice_security(conn) do
    user = Stonehenge.Auth.get_user!(get_session(conn, :current_user_id))
    cond do
      user.email != "admin@stonehenge.com" ->
        render(conn, "exception.json", message: "No permission to access this resouce")
        true -> {:ok}
    end
  end
end
