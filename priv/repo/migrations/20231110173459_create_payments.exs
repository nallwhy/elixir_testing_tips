defmodule ElixirTestingTips.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :amount, :decimal, null: false
      add :status, :string, null: false
      add :created_at, :timestamptz, null: false
      add :requested_at, :timestamptz, null: true
      add :confirmed_at, :timestamptz, null: true
      add :failed_at, :timestamptz, null: true
    end
  end
end
