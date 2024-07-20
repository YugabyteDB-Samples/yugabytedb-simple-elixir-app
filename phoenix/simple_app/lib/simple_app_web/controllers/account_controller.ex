defmodule SimpleAppWeb.AccountController do
  use SimpleAppWeb, :controller

  alias SimpleApp.{Repo, Account}

  import Ecto.Query

  def index(conn, _params) do
    accounts = Repo.all(Account)

    accounts_json = Enum.map(accounts, fn account ->
      %{
        id: account.id,
        name: account.name,
        balance: account.balance
      }
    end)

    json(conn, %{"accounts" => accounts_json})
  end

  def show(conn, %{"id" => id}) do
    account = Repo.one(from a in Account, where: a.id == ^id,
                select: %{id: a.id, name: a.name, balance: a.balance})

    json(conn, account)
  end
end
