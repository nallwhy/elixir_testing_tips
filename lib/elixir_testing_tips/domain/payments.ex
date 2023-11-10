defmodule ElixirTestingTips.Domain.Payments do
  alias ElixirTestingTips.Domain.Payments.Payment
  alias ElixirTestingTips.Repo

  def create_payment(%{amount: amount}) do
    Payment.Command.create(%{amount: amount, created_at: DateTime.utc_now()})
    |> Repo.insert()
  end
end
