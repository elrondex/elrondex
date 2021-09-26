defmodule Elrondex.TransactionSignTest do
  alias Elrondex.{Account, Transaction}

  use ExUnit.Case

  test "require sign fields" do
    assert Transaction.is_required_sign_field(:data) == false

    for field <- Transaction.sign_fields() do
      case field do
        :data -> :ok
        required_field -> assert Transaction.is_required_sign_field(required_field) == true
      end
    end
  end

  test "sign field types" do
    assert Transaction.sign_field_type(:nonce) == :number
    assert Transaction.sign_field_type(:value) == :string
    assert Transaction.sign_field_type(:receiver) == :string
    assert Transaction.sign_field_type(:sender) == :string
    assert Transaction.sign_field_type(:gasPrice) == :number
    assert Transaction.sign_field_type(:gasLimit) == :number
    assert Transaction.sign_field_type(:data) == :string
    assert Transaction.sign_field_type(:chainID) == :string
    assert Transaction.sign_field_type(:version) == :number
  end

  test "prepare nonce" do
    tr = %Transaction{nonce: 1}
    assert Transaction.prepare_sign_field(tr, :nonce) == "\"nonce\":1"
    tr = %{tr | nonce: 10}
    assert Transaction.prepare_sign_field(tr, :nonce) == "\"nonce\":10"
  end

  test "prepare data" do
    tr = %Transaction{data: nil}
    assert Transaction.prepare_sign_field(tr, :data) == nil
    tr = %{tr | data: ""}
    assert Transaction.prepare_sign_field(tr, :data) == nil
    tr = %{tr | data: "data"}
    assert Transaction.prepare_sign_field(tr, :data) == "\"data\":\"ZGF0YQ==\""
  end

  test "prepare value" do
    tr = %Transaction{value: nil}
    assert Transaction.prepare_sign_field(tr, :value) == nil
    tr = %Transaction{value: 1}
    assert Transaction.prepare_sign_field(tr, :value) == "\"value\":\"1\""
    tr = %{tr | value: "1"}
    assert Transaction.prepare_sign_field(tr, :value) == "\"value\":\"1\""
  end
end
