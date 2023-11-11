defmodule ElixirTestingTips.Domain.PaymentsTest do
  use ElixirTestingTips.DataCase
  alias ElixirTestingTips.Domain.Payments
  alias ElixirTestingTips.Domain.Payments.Payment

  describe "create_payment/1" do
    test "with valid attrs" do
      attrs = %{amount: 100}

      assert {:ok, %Payment{} = payment} = Payments.create_payment(attrs)
      assert payment.amount == attrs.amount
      assert payment.status == :pending
      assert payment.created_at != nil
      assert payment.requested_at == nil
      assert payment.confirmed_at == nil
      assert payment.failed_at == nil
    end
  end

  describe "fetch_payment/1" do
    setup do
      payment = Factory.insert(:payment)

      %{payment: payment}
    end

    test "with valid payment_id", %{payment: payment} do
      assert {:ok, fetched_payment} = Payments.fetch_payment(payment.id)
      assert fetched_payment == payment
    end

    test "with invalid payment_id" do
      assert {:error, :not_found} = Payments.fetch_payment(0)
    end
  end
end
