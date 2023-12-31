defmodule ElixirTestingTips.Domain.PaymentsTest do
  use ElixirTestingTips.DataCase
  alias ElixirTestingTips.Domain.Payments
  alias ElixirTestingTips.Domain.Payments.Payment

  describe "create_payment/1" do
    test "with valid attrs" do
      attrs = %{amount: 100}

      assert {:ok, %Payment{} = payment} = Payments.create_payment(attrs)
      assert_same_fields payment, attrs, [:amount]
      assert payment.status == :pending
      assert payment.created_at != nil
      assert payment.requested_at == nil
      assert payment.confirmed_at == nil
      assert payment.failed_at == nil
    end
  end

  describe "request_payment/1" do
    setup do
      payment = Factory.insert(:payment, status: :pending)

      %{payment: payment}
    end

    test "with valid payment_id", %{payment: payment} do
      assert {:ok, %Payment{} = payment} = Payments.request_payment(payment.id)
      assert payment.status == :requested
      assert payment.requested_at != nil
      assert payment.confirmed_at == nil
      assert payment.failed_at == nil
    end

    test "with already requested payment_id" do
      already_requested_payment = Factory.insert(:payment, status: :requested)

      assert {:error, :payment_invalid_status} =
               Payments.request_payment(already_requested_payment.id)
    end

    test "with invalid payment_id" do
      assert {:error, :not_found} = Payments.request_payment(0)
    end
  end

  describe "confirm_payment/1" do
    setup do
      payment = Factory.insert(:payment, status: :requested)

      %{payment: payment}
    end

    test "with valid payment_id", %{payment: payment} do
      assert {:ok, %Payment{} = payment} = Payments.confirm_payment(payment.id)
      assert payment.status == :confirmed
      assert payment.confirmed_at != nil
      assert payment.failed_at == nil
    end
  end

  describe "fail_payment/1" do
    setup do
      payment = Factory.insert(:payment, status: :requested)

      %{payment: payment}
    end

    test "with valid payment_id", %{payment: payment} do
      assert {:ok, %Payment{} = payment} = Payments.fail_payment(payment.id)
      assert payment.status == :failed
      assert payment.failed_at != nil
      assert payment.confirmed_at == nil
    end
  end

  describe "fetch_payment/1" do
    setup do
      payment = Factory.insert(:payment)

      %{payment: payment}
    end

    test "with valid payment_id", %{payment: payment} do
      assert {:ok, fetched_payment} = Payments.fetch_payment(payment.id)
      assert_same_records fetched_payment, payment
    end

    test "with invalid payment_id" do
      assert {:error, :not_found} = Payments.fetch_payment(0)
    end
  end
end
