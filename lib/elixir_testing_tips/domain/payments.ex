defmodule ElixirTestingTips.Domain.Payments do
  alias ElixirTestingTips.Domain.Payments.Payment
  alias ElixirTestingTips.Repo

  def create_payment(%{amount: amount}) do
    Payment.Command.create(%{amount: amount, created_at: DateTime.utc_now()})
    |> Repo.insert()
  end

  def request_payment(payment_id) do
    with {:ok, payment} <- fetch_payment(payment_id),
         :ok <- check_payment_status(payment, :pending),
         {:ok, %Payment{} = _updated_payment} <-
           Payment.Command.request(payment, %{requested_at: DateTime.utc_now()}) |> Repo.update() do
      fetch_payment(payment_id)
    end
  end

  def confirm_payment(payment_id) do
    with {:ok, payment} <- fetch_payment(payment_id),
         :ok <- check_payment_status(payment, :requested),
         {:ok, %Payment{} = _updated_payment} <-
           Payment.Command.confirm(payment, %{confirmed_at: DateTime.utc_now()}) |> Repo.update() do
      fetch_payment(payment_id)
    end
  end

  def fail_payment(payment_id) do
    with {:ok, payment} <- fetch_payment(payment_id),
         :ok <- check_payment_status(payment, :requested),
         {:ok, %Payment{} = _updated_payment} <-
           Payment.Command.fail(payment, %{failed_at: DateTime.utc_now()}) |> Repo.update() do
      fetch_payment(payment_id)
    end
  end

  def fetch_payment(payment_id) do
    Payment.Query.get(payment_id)
    |> Repo.one()
    |> case do
      %Payment{} = payment -> {:ok, payment}
      nil -> {:error, :not_found}
    end
  end

  defp check_payment_status(%Payment{} = payment, status) do
    case payment.status == status do
      true -> :ok
      false -> {:error, :payment_invalid_status}
    end
  end
end
