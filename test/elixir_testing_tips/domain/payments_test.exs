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
end
