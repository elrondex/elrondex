defmodule Elrondex.WrapEgldTest do
  alias Elrondex.{Account, Transaction, Network, REST, ESDT}
  alias Elrondex.Sc.{WrapEgldSc, PairSc}
  use ExUnit.Case

  @wrap_egld_address "erd1qqqqqqqqqqqqqpgqfj3z3k4vlq7dc2928rxez0uhhlq46s6p4mtqerlxhc"
  # Pair Contract
  @pair_egldbusd_address "erd1qqqqqqqqqqqqqpgq3gmttefd840klya8smn7zeae402w2esw0n4sm8m04f"
  # "BUSD-05b16f"
  # "WEGLD-88600a"
  # "EGLDBUSD-855259"

  @tag :skip
  test "wrapEgld test" do
    devnet = Network.get(:testnet)

    # mnemonic = "cost turn honey genre mercy reunion start lion snap box endorse horse cross destroy figure acid glue virtual taxi vital finish option inject inherit"
    mnemonic =
      "fox gauge private vivid repeat cloth time alien service airport dirt coil early purity universe lumber gadget taxi prepare law era social future grace"

    address = "erd1slu8h83pc9kymdfmpzm6wc0r543v4p82mhyeudxcfw3h3wkvy0ksu0y2f4"

    value = "2000000000000000000"
    data = "wrapEgld"

    tx_hash =
      mnemonic
      |> Account.from_mnemonic()
      |> Transaction.transaction(@wrap_egld_address, value, data)
      |> Map.put(:gasLimit, 8_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "check wrapEgld" do
    devnet = Network.devnet()

    # My 
    address = "erd1ut3wf73j30x6l0suvn7dyequ6yex7lw08k8pup2l25027ee3xl2qenfh8m"
    # Example
    address = "erd1j9w8n9x9q8rly35t7k6a49956a775f08rjda0chs743gu7ypar9q802l4r"
    # 
    address = @wrap_egld_address
    address = @pair_egldbusd_address

    {:ok, esdt} = REST.get_address_esdt(devnet, address)
    IO.inspect(esdt)

    esdt
    |> Map.keys()
    |> Enum.join("\n")
    |> IO.inspect()
  end

  @tag :skip
  test "accounts" do
    devnet = Network.get(:testnet)

    # mnemonic = "cost turn honey genre mercy reunion start lion snap box endorse horse cross destroy figure acid glue virtual taxi vital finish option inject inherit"
    mnemonic =
      "fox gauge private vivid repeat cloth time alien service airport dirt coil early purity universe lumber gadget taxi prepare law era social future grace"

    address = "erd1slu8h83pc9kymdfmpzm6wc0r543v4p82mhyeudxcfw3h3wkvy0ksu0y2f4"

    value = "2000000000000000000"
    data = "wrapEgld"

    account0 =
      mnemonic
      |> Account.from_mnemonic("", 0)

    IO.inspect(account0.address)

    account1 =
      mnemonic
      |> Account.from_mnemonic("", 1)

    IO.inspect(account1.address)
  end

  @tag :skip
  test "network" do
    # network = Network.get(:testnet)
    network = Network.get(:mainnet)
    IO.inspect(network)
  end

  def mnemonic() do
    "grace ribbon fix surge genuine vote food soccer fringe entire energy frost bind rather sail finish enhance flavor hurdle sudden warm isolate coyote loan"
  end

  @tag :skip
  test "transaction wrap" do
    network = Network.get(:testnet)

    sign_tr = transaction_wrap(mnemonic(), 0, 18, 2, network)
    sign_tr1 = sign_tr
    json = Jason.encode!(sign_tr, pretty: true)
    IO.inspect(json)
    sign_tr2 = Jason.decode!(json)
    assert sign_tr1 = sign_tr1
    # Write to disk
    File.write!("05wrap.json", json)
  end

  @tag :skip
  test "transaction swap" do
    network = Network.get(:testnet)

    sign_tr = transaction_swap(mnemonic(), 0, 19, 2, network)
    sign_tr1 = sign_tr
    json = Jason.encode!(sign_tr, pretty: true)
    IO.inspect(json)
    sign_tr2 = Jason.decode!(json)
    assert sign_tr1 = sign_tr1
    # Write to disk
    File.write!("05swap.json", json)
  end

  @tag :skip
  test "load transaction and send" do
    network = Network.get(:testnet)
    # Tr1 wrap
    tx_data = Jason.decode!(File.read!("0-wrap.json"))
    IO.inspect(tx_data)
    tx = REST.post_transaction_send(tx_data, network)
    IO.inspect(tx)
    # Tr2 swap
    tx_data = Jason.decode!(File.read!("0-swap.json"))
    IO.inspect(tx_data)
    tx = REST.post_transaction_send(tx_data, network)
    IO.inspect(tx)
  end

  # Prod
  @tag :skip
  test "load transaction prod" do
    network = Network.get(:mainnet)
    # Tr1 wrap
    tx_data = Jason.decode!(File.read!("9-wrap.json"))
    IO.inspect(tx_data)
    tx = REST.post_transaction_send(tx_data, network)
    IO.inspect(tx)
  end

  @tag timeout: :infinity
  test "load swaps prod" do
    pair_state(:start)
  end

  def pair_state(:active) do
    do_all_swap()
  end

  def pair_state(state) do
    IO.inspect(state)
    :timer.sleep(5000)
    mainnet = Network.get(:mainnet)
    pair_egldmex_address = "erd1qqqqqqqqqqqqqpgqa0fsfshnff4n76jhcye6k7uvd7qacsq42jpsp6shh2"

    new_state =
      case PairSc.get_state(pair_egldmex_address, mainnet) do
        {:ok, state} ->
          state

        {:error, error} ->
          IO.inspect(error)
          :error
      end

    pair_state(new_state)
  end

  def do_all_swap() do
    do_swap(5)
    do_swap(6)
    do_swap(7)
    do_swap(8)
    do_swap(9)
  end

  def do_swap(index) do
    network = Network.get(:mainnet)
    # Tr2 swap
    tx_data = Jason.decode!(File.read!("#{index}-swap.json"))
    IO.inspect(tx_data)
    tx = REST.post_transaction_send(tx_data, network)
    IO.inspect(tx)
  end

  @tag :skip
  test "generate all" do
    network = Network.get(:testnet)
    # generate_tr(mnemonic(), 0, 20, 1, network)
    list = [{5, 3, 6}, {6, 3, 6}, {7, 3, 5}, {8, 1, 12}, {9, 0, 10}]
    generate_tr_list(list, mnemonic(), network)
  end

  def generate_tr_list([], mnemonic, network) do
  end

  def generate_tr_list([{index, nonce, value} | t], mnemonic, network) do
    generate_tr(mnemonic, index, nonce, value, network)
    generate_tr_list(t, mnemonic, network)
  end

  def generate_tr(mnemonic, index, nonce, value, network) do
    # Tr 1 wrap
    sign_tr = transaction_wrap(mnemonic, index, nonce, value, network)
    json = Jason.encode!(sign_tr, pretty: true)
    IO.inspect(json)
    File.write!("#{index}-wrap.json", json)
    # Tr 2 
    sign_tr = transaction_swap(mnemonic, index, nonce + 1, value, network)
    json = Jason.encode!(sign_tr, pretty: true)
    File.write!("#{index}-swap.json", json)
  end

  def transaction_wrap(mnemonic, index, nonce, value, network) do
    account =
      mnemonic
      |> Account.from_mnemonic("", index)

    transaction =
      account
      |> WrapEgldSc.wrap_egld(value * 1_000_000_000_000_000_000)

    transaction = %{
      transaction
      | gasPrice: network.erd_min_gas_price,
        chainID: network.erd_chain_id,
        version: network.erd_min_transaction_version,
        nonce: nonce
    }

    sign_tr = transaction |> Transaction.sign()
    Transaction.to_signed_map(sign_tr)
  end

  def transaction_swap(mnemonic, index, nonce, value, network) do
    account =
      mnemonic
      |> Account.from_mnemonic("", index)

    pair_address = "erd1qqqqqqqqqqqqqpgqr82hqynfa7e2hvg4e4kyekuhy9j2739m2jpspjljhd"
    {:ok, pair} = PairSc.get_pair(pair_address, network)

    transaction =
      account
      |> PairSc.swap_tokens_fixed_input(
        pair,
        pair.first_token,
        value * 1_000_000_000_000_000_000,
        pair.second_token,
        value * 1_400_000 * 1_000_000_000_000_000_000
      )

    transaction = %{
      transaction
      | gasPrice: network.erd_min_gas_price,
        chainID: network.erd_chain_id,
        version: network.erd_min_transaction_version,
        nonce: nonce
    }

    sign_tr = transaction |> Transaction.sign()
    Transaction.to_signed_map(sign_tr)
  end
end
