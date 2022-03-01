defmodule Manual.PairScTest do
  use ExUnit.Case

  alias Elrondex.{Network, Account, REST, Transaction, Test, ESDT}
  alias Elrondex.Sc.{PairSc, RouterSc}

  @mnemonic "grace ribbon fix surge genuine vote food soccer fringe entire energy frost bind rather sail finish enhance flavor hurdle sudden warm isolate coyote loan"
  @account Account.from_mnemonic(@mnemonic)

  @network Network.get(:testnet)

  @router_addr "erd1qqqqqqqqqqqqqpgq37e5r67hvtrkyhs6yadwvwtk3rxk792e0n4s066pa5"
  @wegld_ride_addr "erd1qqqqqqqqqqqqqpgqcrqkv49gh7zlyereyxsrclpfl2rwrw3h0n4sq9cpus"

  @tag :skip
  test "get router address" do
    # wegld/usdc 
    pair_addr = "erd1qqqqqqqqqqqqqpgqmswpnctwjkw9d8m7dpnmshduf49n2zlw0n4skjhuu2"

    router_addr = PairSc.get_router_managed_address(pair_addr, @network)
    IO.inspect(router_addr)
  end

  @tag :skip
  test "get all pairs" do
    addr = RouterSc.get_all_pairs(@router_addr, @network)
    IO.inspect(addr)
  end

  @tag :skip
  test "add_liquidity" do
    {:ok, pair} = PairSc.get_pair(@wegld_ride_addr, @network)

    transaction =
      PairSc.add_liquidity(
        @account,
        pair,
        100_000_000_000_000_000,
        10_289_630_063_883_110_167
      )

    {:ok, tx_hash} =
      transaction
      |> Transaction.prepare(@network)
      |> Map.put(:gasLimit, 50_000_000)
      |> Transaction.sign()
      |> Elrondex.REST.post_transaction_send()

    IO.puts("tx_hash: #{tx_hash}")
  end

  @tag :skip
  test "get_lp_token_identifier" do
    {:ok, lp_token} = PairSc.get_lp_token_identifier(@wegld_ride_addr, @network)
    # IO.inspect(lp_token)
    assert lp_token == "EGLDRIDE-f8c488"
  end

  @tag :skip
  test "get_pair_test" do
    rez = PairSc.get_pair(@wegld_ride_addr, @network)
    IO.inspect(rez)
  end

  @tag :skip
  test "get_total_lp_token_supply" do
    rez = PairSc.get_total_lp_token_supply(@wegld_ride_addr, @network)
    IO.inspect(rez)
  end

  @tag :skip
  test "get_address_balance" do
    addr = "erd1eqkvd2r9h5uzyvj7kxs0s2g066axnpru7njr4c6fcxp53a6dcnyq38zp95"
    rez = REST.get_address_balance(@network, addr)
    IO.inspect(rez)
  end

  # TODO

  @tag :skip
  # total lp: 			  14607757112398009698838
  # value I have in pool: 3032

  # Y/X = P%
  # x = 14607757112398009698838
  # y = 3032

  # 3032 / 14607757112398009698838 = 0.002 ... %
  # I have 0.002% of LP

  test "remove_liquidity" do
  end
end
