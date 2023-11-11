defmodule ElixirTestingTips.Factory do
  alias ElixirTestingTips.Repo
  alias ElixirTestingTips.Domain.Payments.Payment

  def build(:payment) do
    %Payment{
      amount: Decimal.new(100),
      status: :pending,
      created_at: DateTime.utc_now()
    }
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
