defmodule Elrondex.Sc.PairScTest do
  alias Elrondex.{Account, Transaction, Network, REST, Pair}
  alias Elrondex.Sc.PairSc

  use ExUnit.Case

  def account() do
    mnemonic =
      "cost turn honey genre mercy reunion start lion snap box endorse horse cross destroy figure acid glue virtual taxi vital finish option inject inherit"

    # address = "erd1ut3wf73j30x6l0suvn7dyequ6yex7lw08k8pup2l25027ee3xl2qenfh8m"

    mnemonic
    |> Account.from_mnemonic()
  end

  @tag :skip
  test "acceptEsdtPayment 1 EGLD" do
    devnet = Network.get(:devnet)
    pair = Pair.get_egldbusd_pair()

    tx_hash =
      account()
      |> PairSc.accept_esdt_payment(pair, pair.first_token, 1_000_000_000_000_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "acceptEsdtPayment 128 BUSD" do
    devnet = Network.get(:devnet)
    pair = Pair.get_egldbusd_pair()

    tx_hash =
      account()
      |> PairSc.accept_esdt_payment(pair, pair.second_token, 128_000_000_000_000_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "getTemporaryFunds EGLD" do
    devnet = Network.get(:devnet)
    pair = Pair.get_egldbusd_pair()

    tx_hash =
      account()
      |> PairSc.temporary_funds(pair, pair.first_token)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "getTemporaryFunds BUSD" do
    devnet = Network.get(:devnet)
    pair = Pair.get_egldbusd_pair()

    tx_hash =
      account()
      |> PairSc.temporary_funds(pair, pair.second_token)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "getTemporaryFunds EGLD for another address" do
    devnet = Network.get(:devnet)
    pair = Pair.get_egldbusd_pair()

    account =
      Account.from_address("erd1n9ydmhy6qwl2jxm8028ry7fr8g0jua3s4r9avylzv7kvthwetqxsvf0tne")

    tx_hash =
      account()
      |> PairSc.temporary_funds(pair, account.public_key, pair.first_token)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "getEquivalent 1 EGLD" do
    devnet = Network.get(:devnet)
    pair = Pair.get_egldbusd_pair()

    tx_hash =
      account()
      |> PairSc.get_equivalent(pair, pair.first_token, 1_000_000_000_000_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
    # 128_776993_450298_025557
  end

  @tag :skip
  test "getEquivalent 200 BUSD" do
    devnet = Network.get(:devnet)
    pair = Pair.get_egldbusd_pair()

    tx_hash =
      account()
      |> PairSc.get_equivalent(pair, pair.second_token, 200_000_000_000_000_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
    # 1_553094_565073_797616
  end

  @tag :skip
  test "get_amount_in, 2 EDGL wanted" do
    devnet = Network.get(:devnet)
    pair = Pair.get_egldbusd_pair()

    tx_hash =
      account()
      |> PairSc.get_amount_in(pair, pair.first_token, 2_000_000_000_000_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
    # 258 323186 356147 746356 BUSD
  end

  @tag :skip
  test "get_amount_in, 200 BUSD wanted" do
    devnet = Network.get(:devnet)
    pair = Pair.get_egldbusd_pair()

    tx_hash =
      account()
      |> PairSc.get_amount_in(pair, pair.second_token, 200_000_000_000_000_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
    # 1 557793 802901 360200 EGLD
  end

  @tag :skip
  test "get_amount_out, 1 EGLD in" do
    devnet = Network.get(:devnet)
    pair = Pair.get_egldbusd_pair()

    tx_hash =
      account()
      |> PairSc.get_amount_out(pair, pair.first_token, 1_000_000_000_000_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
    # 128 389943 356123 207714 BUSD
  end

  @tag :skip
  test "get_amount_out, 150 BUSD in" do
    devnet = Network.get(:devnet)
    pair = Pair.get_egldbusd_pair()

    tx_hash =
      account()
      |> PairSc.get_amount_out(pair, pair.second_token, 150_000_000_000_000_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
    # 1 161318 325339 052503 
  end
end
