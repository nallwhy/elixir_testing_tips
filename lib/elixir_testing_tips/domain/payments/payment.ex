defmodule ElixirTestingTips.Domain.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :amount, :decimal

    field :status, Ecto.Enum,
      values: [:pending, :requested, :confirmed, :failed],
      default: :pending

    field :created_at, :utc_datetime_usec
    field :requested_at, :utc_datetime_usec
    field :confirmed_at, :utc_datetime_usec
    field :failed_at, :utc_datetime_usec

    field :updated_at, :utc_datetime_usec, virtual: true
  end

  def changeset_for_create(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, [:amount, :created_at])
    |> validate_required([:amount, :created_at])
  end

  def changeset_for_request(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, [:status, :requested_at])
    |> validate_required([:requested_at])
  end

  def changeset_for_confirm(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, [:status, :confirmed_at])
    |> validate_required([:confirmed_at])
  end

  def changeset_for_fail(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, [:status, :failed_at])
    |> validate_required([:failed_at])
  end

  defmodule Command do
    alias ElixirTestingTips.Domain.Payments.Payment

    def create(attrs) do
      %Payment{}
      |> Payment.changeset_for_create(attrs)
    end

    def request(%Payment{} = payment, attrs) do
      attrs = attrs |> Map.merge(%{status: :requested})

      payment
      |> Payment.changeset_for_request(attrs)
    end

    def confirm(%Payment{} = payment, attrs) do
      attrs = attrs |> Map.merge(%{status: :confirmed})

      payment
      |> Payment.changeset_for_confirm(attrs)
    end

    def fail(%Payment{} = payment, attrs) do
      attrs = attrs |> Map.merge(%{status: :failed})

      payment
      |> Payment.changeset_for_fail(attrs)
    end
  end

  defmodule Query do
    import Ecto.Query
    alias ElixirTestingTips.Domain.Payments.Payment

    def get(id) do
      Payment
      |> where([p], p.id == ^id)
      |> select([p], %{
        p
        | updated_at:
            p.failed_at
            |> coalesce(p.confirmed_at)
            |> coalesce(p.requested_at)
            |> coalesce(p.created_at)
      })
    end
  end
end
