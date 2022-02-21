defmodule Manual.PairScTest do
  use ExUnit.Case
  doctest Elrondex.Sc.PairSc

  alias Elrondex.{Network, Account, REST, Transaction, Test}
  alias Elrondex.Sc.{PairSc}

  @mnemonic "grace ribbon fix surge genuine vote food soccer fringe entire energy frost bind rather sail finish enhance flavor hurdle sudden warm isolate coyote loan"
  @account Account.from_mnemonic(@mnemonic)

  @pair_address "erd1qqqqqqqqqqqqqpgqmswpnctwjkw9d8m7dpnmshduf49n2zlw0n4skjhuu2"
  @wrap_egld_address "erd1qqqqqqqqqqqqqpgqd77fnev2sthnczp2lnfx0y5jdycynjfhzzgq6p3rax"

  @network Network.get(:testnet)

  @tag :skip
  test "swap_egld_to_wrap_egld" do
    value = "5000000000000000000"
    data = "wrapEgld"

    tx_hash =
      @mnemonic
      |> Account.from_mnemonic()
      |> Transaction.transaction(@wrap_egld_address, value, data)
      |> Map.put(:gasLimit, 8_000_000)
      |> Transaction.prepare(@network)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "swap_tokens_fixed_input WEGLD -> USDC" do
    IO.puts("swap_tokens_fixed_input EGLD -> USDC")
    IO.puts("------------------------------------------")

    {:ok, pair} = PairSc.get_pair(@pair_address, @network)

    transaction =
      PairSc.swap_tokens_fixed_input(
        @account,
        pair,
        pair.first_token,
        1000_000_000_000_000_000,
        pair.second_token,
        2 * 50 * 1_000_000
      )

    {:ok, tx_hash} =
      transaction
      |> Transaction.prepare(@network)
      |> Transaction.sign()
      |> Elrondex.REST.post_transaction_send()

    IO.puts("tx_hash: #{tx_hash}")
  end

  # @tag :ship
  test "prepare doctest swap_tokens_fixed_input" do
    pair = Test.Utils.wegld_usdc_pair()
    account = Test.Bob.account()

    transaction =
      PairSc.swap_tokens_fixed_input(
        account,
        pair,
        pair.first_token,
        1000_000_000_000_000_000,
        pair.second_token,
        2 * 50 * 1_000_000
      )

    assert Map.get(transaction, :data) ==
             "ESDTTransfer@5745474c442d626434643739@0de0b6b3a7640000@73776170546f6b656e734669786564496e707574@555344432d633736663166@05f5e100"
  end
end
