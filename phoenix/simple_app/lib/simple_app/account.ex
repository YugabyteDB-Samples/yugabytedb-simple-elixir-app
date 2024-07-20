defmodule SimpleApp.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "account" do
    field :name, :string
    field :balance, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :balance])
    |> validate_required([:name, :balance])
  end
end
