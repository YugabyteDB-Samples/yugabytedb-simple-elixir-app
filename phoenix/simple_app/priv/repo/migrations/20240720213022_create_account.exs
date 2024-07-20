defmodule SimpleApp.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:account) do
      add :name, :string
      add :balance, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
