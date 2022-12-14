defmodule QuestionaireLiveWeb.DepositControllerTest do
  use QuestionaireLiveWeb.ConnCase

  import QuestionaireLive.AccountsFixtures

  @create_attrs %{account_transaction_id: 42, amount: "some amount", msisdn: "some msisdn", "ref.no": "some ref.no"}
  @update_attrs %{account_transaction_id: 43, amount: "some updated amount", msisdn: "some updated msisdn", "ref.no": "some updated ref.no"}
  @invalid_attrs %{account_transaction_id: nil, amount: nil, msisdn: nil, "ref.no": nil}

  describe "index" do
    test "lists all deposits", %{conn: conn} do
      conn = get(conn, Routes.deposit_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Deposits"
    end
  end

  describe "new deposit" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.deposit_path(conn, :new))
      assert html_response(conn, 200) =~ "New Deposit"
    end
  end

  describe "create deposit" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.deposit_path(conn, :create), deposit: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.deposit_path(conn, :show, id)

      conn = get(conn, Routes.deposit_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Deposit"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.deposit_path(conn, :create), deposit: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Deposit"
    end
  end

  describe "edit deposit" do
    setup [:create_deposit]

    test "renders form for editing chosen deposit", %{conn: conn, deposit: deposit} do
      conn = get(conn, Routes.deposit_path(conn, :edit, deposit))
      assert html_response(conn, 200) =~ "Edit Deposit"
    end
  end

  describe "update deposit" do
    setup [:create_deposit]

    test "redirects when data is valid", %{conn: conn, deposit: deposit} do
      conn = put(conn, Routes.deposit_path(conn, :update, deposit), deposit: @update_attrs)
      assert redirected_to(conn) == Routes.deposit_path(conn, :show, deposit)

      conn = get(conn, Routes.deposit_path(conn, :show, deposit))
      assert html_response(conn, 200) =~ "some updated amount"
    end

    test "renders errors when data is invalid", %{conn: conn, deposit: deposit} do
      conn = put(conn, Routes.deposit_path(conn, :update, deposit), deposit: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Deposit"
    end
  end

  describe "delete deposit" do
    setup [:create_deposit]

    test "deletes chosen deposit", %{conn: conn, deposit: deposit} do
      conn = delete(conn, Routes.deposit_path(conn, :delete, deposit))
      assert redirected_to(conn) == Routes.deposit_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.deposit_path(conn, :show, deposit))
      end
    end
  end

  defp create_deposit(_) do
    deposit = deposit_fixture()
    %{deposit: deposit}
  end
end
