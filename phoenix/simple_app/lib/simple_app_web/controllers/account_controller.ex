defmodule SimpleAppWeb.AccountController do
  use SimpleAppWeb, :controller

  def accounts(conn, _params) do
    render(conn, :accounts)
  end

  def show(conn, %{"id" => id}) do
    render(conn, :show, id: id)
  end
end
