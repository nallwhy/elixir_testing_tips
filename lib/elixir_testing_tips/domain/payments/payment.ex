defmodule ElixirTestingTips.Domain.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

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

  def changeset_for_create(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, [:amount, :created_at])
    |> validate_required([:amount, :created_at])
  end

  defmodule Command do
    alias ElixirTestingTips.Domain.Payments.Payment

    def create(attrs) do
      %Payment{}
      |> Payment.changeset_for_create(attrs)
    end
  end
end
