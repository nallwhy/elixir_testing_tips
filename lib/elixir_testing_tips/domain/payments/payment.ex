defmodule ElixirTestingTips.Domain.Payments.Payment do
  use Ecto.Schema

  schema "payments" do
    field :amount, :decimal

    field :status, Ecto.Enum,
      values: [:pending, :requested, :confirmed, :failed],
      default: :pending

    field :created_at, :utc_datetime
    field :requested_at, :utc_datetime
    field :confirmed_at, :utc_datetime
    field :failed_at, :utc_datetime
  end
end
