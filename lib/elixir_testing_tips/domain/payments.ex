defmodule ElixirTestingTips.Domain.Payments do
  alias ElixirTestingTips.Domain.Payments.Payment
  alias ElixirTestingTips.Repo

  def create_payment(%{amount: amount}) do
    Payment.Command.create(%{amount: amount, created_at: DateTime.utc_now()})
    |> Repo.insert()
  end

  def fetch_payment(payment_id) do
    Payment.Query.get(payment_id)
    |> Repo.one()
    |> case do
      %Payment{} = payment -> {:ok, payment}
      nil -> {:error, :not_found}
    end
  end
end
