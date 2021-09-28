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

  @tag :skip
  test "get_first_token_id" do
    testnet = Network.get(:testnet)

    pair1 = "erd1qqqqqqqqqqqqqpgquh2r06qrjesfv5xj6v8plrqm93c6xvw70n4sfuzpmc"
    pair2 = "erd1qqqqqqqqqqqqqpgqmffr70826epqhdf2ggsmgxgur77g53hr0n4s38y2qe"

    rez_sc_call =
      pair1
      |> PairSc.get_first_token_id(testnet)

    IO.inspect(rez_sc_call)

    rez_sc_call =
      pair1
      |> PairSc.get_second_token_id(testnet)

    IO.inspect(rez_sc_call)

    rez_sc_call =
      pair2
      |> PairSc.get_first_token_id(testnet)

    IO.inspect(rez_sc_call)

    rez_sc_call =
      pair2
      |> PairSc.get_second_token_id(testnet)

    IO.inspect(rez_sc_call)
  end

  @tag :skip
  test "get_reserve" do
    testnet = Network.get(:testnet)

    pair1 = "erd1qqqqqqqqqqqqqpgquh2r06qrjesfv5xj6v8plrqm93c6xvw70n4sfuzpmc"

    rez_sc_call =
      pair1
      |> PairSc.get_reserve("WEGLD-073650", testnet)

    IO.inspect(rez_sc_call)

    rez_sc_call =
      pair1
      |> PairSc.get_reserve("MEX-ec32fa", testnet)

    IO.inspect(rez_sc_call)
  end

  @tag :skip
  test "get_total_lp_token_supply" do
    testnet = Network.get(:testnet)

    pair1 = "erd1qqqqqqqqqqqqqpgquh2r06qrjesfv5xj6v8plrqm93c6xvw70n4sfuzpmc"

    rez_sc_call =
      pair1
      |> PairSc.get_total_lp_token_supply(testnet)

    IO.inspect(rez_sc_call)
  end

  @tag :skip
  test "get_lp_token_identifier" do
    testnet = Network.get(:testnet)

    pair1 = "erd1qqqqqqqqqqqqqpgquh2r06qrjesfv5xj6v8plrqm93c6xvw70n4sfuzpmc"

    rez_sc_call =
      pair1
      |> PairSc.get_lp_token_identifier(testnet)

    IO.inspect(rez_sc_call)
  end

  @tag :skip
  test "get_pair" do
    testnet = Network.get(:testnet)

    pair1 = "erd1qqqqqqqqqqqqqpgquh2r06qrjesfv5xj6v8plrqm93c6xvw70n4sfuzpmc"

    rez_sc_call =
      pair1
      |> PairSc.get_pair(testnet)

    IO.inspect(rez_sc_call)
  end
end
