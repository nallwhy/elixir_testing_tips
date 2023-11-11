defmodule ElixirTestingTips.Factory do
  alias ElixirTestingTips.Repo
  alias ElixirTestingTips.Domain.Payments.Payment

  defp do_build(:payment, attributes) do
    {status, attributes} = attributes |> Map.pop(:status, :pending)

    %Payment{
      amount: Decimal.new(100)
    }
    |> apply_payment_status(status, attributes)
  end

  defp apply_payment_status(%Payment{} = payment, :pending, _attributes) do
    %Payment{payment | status: :pending, created_at: now()}
  end

  defp apply_payment_status(%Payment{} = payment, :requested, attributes) do
    payment =
      payment
      |> apply_payment_status(:pending, attributes)

    %Payment{payment | status: :requested, requested_at: now()}
  end

  defp apply_payment_status(%Payment{} = payment, :confirmed, attributes) do
    payment =
      payment
      |> apply_payment_status(:requested, attributes)

    %Payment{payment | status: :confirmed, confirmed_at: now()}
  end

  defp apply_payment_status(%Payment{} = payment, :failed, attributes) do
    payment =
      payment
      |> apply_payment_status(:requested, attributes)

    %Payment{payment | status: :failed, failed_at: now()}
  end

  # Convenience API
  def build(factory_name, attributes) when is_map(attributes) do
    factory_name |> do_build(attributes) |> struct!(attributes)
  end

  def build(factory_name, attributes) do
    build(factory_name, Map.new(attributes))
  end

  def insert(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end

  defp now() do
    DateTime.utc_now()
  end
end
