defmodule SimpleApp.Repo do
  use Ecto.Repo,
    otp_app: :simple_app,
    adapter: Ecto.Adapters.Postgres
end
