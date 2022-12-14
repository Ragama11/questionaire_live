defmodule QuestionaireLiveWeb.WithdrawalControllerTest do
  use QuestionaireLiveWeb.ConnCase

  import QuestionaireLive.AccountsFixtures

  @create_attrs %{account_transaction_id: 42, amount: 42, msisdn: "some msisdn", reference_number: "some reference_number"}
  @update_attrs %{account_transaction_id: 43, amount: 43, msisdn: "some updated msisdn", reference_number: "some updated reference_number"}
  @invalid_attrs %{account_transaction_id: nil, amount: nil, msisdn: nil, reference_number: nil}

  describe "index" do
    test "lists all withdrawals", %{conn: conn} do
      conn = get(conn, Routes.withdrawal_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Withdrawals"
    end
  end

  describe "new withdrawal" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.withdrawal_path(conn, :new))
      assert html_response(conn, 200) =~ "New Withdrawal"
    end
  end

  describe "create withdrawal" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.withdrawal_path(conn, :create), withdrawal: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.withdrawal_path(conn, :show, id)

      conn = get(conn, Routes.withdrawal_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Withdrawal"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.withdrawal_path(conn, :create), withdrawal: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Withdrawal"
    end
  end

  describe "edit withdrawal" do
    setup [:create_withdrawal]

    test "renders form for editing chosen withdrawal", %{conn: conn, withdrawal: withdrawal} do
      conn = get(conn, Routes.withdrawal_path(conn, :edit, withdrawal))
      assert html_response(conn, 200) =~ "Edit Withdrawal"
    end
  end

  describe "update withdrawal" do
    setup [:create_withdrawal]

    test "redirects when data is valid", %{conn: conn, withdrawal: withdrawal} do
      conn = put(conn, Routes.withdrawal_path(conn, :update, withdrawal), withdrawal: @update_attrs)
      assert redirected_to(conn) == Routes.withdrawal_path(conn, :show, withdrawal)

      conn = get(conn, Routes.withdrawal_path(conn, :show, withdrawal))
      assert html_response(conn, 200) =~ "some updated msisdn"
    end

    test "renders errors when data is invalid", %{conn: conn, withdrawal: withdrawal} do
      conn = put(conn, Routes.withdrawal_path(conn, :update, withdrawal), withdrawal: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Withdrawal"
    end
  end

  describe "delete withdrawal" do
    setup [:create_withdrawal]

    test "deletes chosen withdrawal", %{conn: conn, withdrawal: withdrawal} do
      conn = delete(conn, Routes.withdrawal_path(conn, :delete, withdrawal))
      assert redirected_to(conn) == Routes.withdrawal_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.withdrawal_path(conn, :show, withdrawal))
      end
    end
  end

  defp create_withdrawal(_) do
    withdrawal = withdrawal_fixture()
    %{withdrawal: withdrawal}
  end
end
