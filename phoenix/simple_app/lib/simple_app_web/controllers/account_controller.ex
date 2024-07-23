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

  def create(conn, %{"name" => name, "balance" => balance}) do
    account_params = %{"name" => name, "balance" => balance}
    changeset = Account.changeset(%Account{}, account_params)

    case Repo.insert(changeset) do
      {:ok, account} ->
        conn
        |> put_status(:created)
        |> json(%{account: Map.from_struct(account) |> Map.drop([:__meta__])})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end

  def delete(conn, %{"id" => id}) do
    try do
      account = Repo.get!(Account, id)
      case Repo.delete(account) do
        {:ok, _account} ->
          conn
          |> put_status(:ok)
          |> json(%{message: "Account deleted successfully"})
        {:error, _reason} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{errors: "Failed to delete account"})
      end
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Account not found"})
      end
  end

  def transfer(conn, %{"from" => from_id, "to" => to_id, "amount" => amount}) do
    amount = Decimal.new(amount)

    result = Repo.transaction(fn ->
      from_account = Repo.get!(Account, from_id)
      to_account = Repo.get!(Account, to_id)

      if from_account.balance < amount do
        Repo.rollback("Insufficient funds")
      else
        from_changeset = Account.changeset(from_account, %{balance: Decimal.sub(from_account.balance, amount)})
        to_changeset = Account.changeset(to_account, %{balance: Decimal.add(to_account.balance, amount)})

        case {Repo.update(from_changeset), Repo.update(to_changeset)} do
          {{:ok, _}, {:ok, _}} ->
            :ok
          _ ->
            Repo.rollback("Transfer failed")
        end
      end
    end)

    case result do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Transfer successful"})
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  rescue
    Ecto.NoResultsError ->
      conn
      |> put_status(:not_found)
      |> json(%{error: "One or both accounts not found"})
    end

end
