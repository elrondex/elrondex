defmodule Elrondex.Sc.WrapEgldScTest do
  alias Elrondex.{Account, Transaction, Network, REST}
  alias Elrondex.Sc.WrapEgldSc

  use ExUnit.Case

  def account() do
    mnemonic =
      "cost turn honey genre mercy reunion start lion snap box endorse horse cross destroy figure acid glue virtual taxi vital finish option inject inherit"

    # address = "erd1ut3wf73j30x6l0suvn7dyequ6yex7lw08k8pup2l25027ee3xl2qenfh8m"

    mnemonic
    |> Account.from_mnemonic()
  end

  @tag :skip
  test "wrapEgld test" do
    devnet = Network.get(:devnet)

    value = 100_000_000_000_000_000_000

    tx_hash =
      account()
      |> WrapEgldSc.wrap_egld(value)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "unwrapEgld test" do
    devnet = Network.get(:devnet)

    value = 100_000_000_000_000_000_000

    tx_hash =
      account()
      |> WrapEgldSc.unwrap_egld(value)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "unwrapEgld test new" do
    devnet = Network.get(:devnet)

    value = 100_000_000_000_000_000_000

    assert {:ok, sc_call} =
             account()
             |> WrapEgldSc.unwrap_egld(value)
             |> SC.call()
  end

  @tag :skip
  test "get_locked_egld_balance test" do
    testnet = Network.get(:testnet)

    {:ok, value} =
      WrapEgldSc.wrapped_egld_address()
      |> WrapEgldSc.get_locked_egld_balance(testnet)

    IO.inspect(value)
  end

  test "get_wrapped_egld_token_id test" do
    testnet = Network.get(:testnet)

    {:ok, value} =
      WrapEgldSc.wrapped_egld_address()
      |> WrapEgldSc.get_wrapped_egld_token_id(testnet)

    IO.inspect(value)

    assert value == WrapEgldSc.wrapped_egld_token_id()
  end
end
