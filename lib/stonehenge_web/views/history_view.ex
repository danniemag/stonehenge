defmodule StonehengeWeb.HistoryView do
  use StonehengeWeb, :view
  alias StonehengeWeb.HistoryView

  def render("index.json", %{histories: histories}) do
    %{data: render_many(histories, HistoryView, "history.json")}
  end

  def render("show.json", %{history: history}) do
    %{data: render_one(history, HistoryView, "history.json")}
  end

  def render("history.json", %{history: history}) do
    %{id: history.id,
      operation_type: history.operation_type,
      value: history.value,
      origin_account: history.origin_account,
      destination_account: history.destination_account,
      created_at: history.inserted_at
    }
  end

  def render("backoffice.json", %{credit_sum: credit_sum_current_day,
                                  debit_sum_current_day: debit_sum_current_day, 
                                  credit_sum_current_month: credit_sum_current_month, 
                                  debit_sum_current_month: debit_sum_current_month, 
                                  credit_sum_current_year: credit_sum_current_year, 
                                  debit_sum_current_year: debit_sum_current_year}) do
    %{
      data: %{
        current_day: %{
          credit_sum: credit_sum_current_day,
          debit_sum: debit_sum_current_day
        },
        current_month: %{
          credit_sum: credit_sum_current_month,
          debit_sum: debit_sum_current_month
        },
        current_year: %{
          credit_sum: credit_sum_current_year,
          debit_sum: debit_sum_current_year
        }
      }
    }
  end


    # ------- UserController Exceptions

    def render("exception.json", %{message: message}) do
      %{errors: %{detail: message}}
    end
end
