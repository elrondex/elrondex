defmodule Manual.LiquidityTest do
  use ExUnit.Case

  alias Elrondex.{Network, Account, REST, Transaction, Test, ESDT}
  alias Elrondex.Sc.{PairSc, RouterSc}

  @mnemonic "grace ribbon fix surge genuine vote food soccer fringe entire energy frost bind rather sail finish enhance flavor hurdle sudden warm isolate coyote loan"
  @account Account.from_mnemonic(@mnemonic)

  @network Network.get(:testnet)

  @router_addr "erd1qqqqqqqqqqqqqpgq37e5r67hvtrkyhs6yadwvwtk3rxk792e0n4s066pa5"
  @wegld_ride_addr "erd1qqqqqqqqqqqqqpgqcrqkv49gh7zlyereyxsrclpfl2rwrw3h0n4sq9cpus"

  def lp_percent_egld_ride() do
    {:ok, raw_total_supply} = PairSc.get_total_lp_token_supply(@wegld_ride_addr, @network)

    {:ok, esdts} =
      REST.get_address_esdt(
        @network,
        "erd1eqkvd2r9h5uzyvj7kxs0s2g066axnpru7njr4c6fcxp53a6dcnyq38zp95"
      )

    raw_liquidity =
      Map.get(esdts, "EGLDRIDE-f8c488") |> Map.get("balance") |> String.to_integer(10)

    {:ok, contract} =
      REST.get_address_esdt(
        @network,
        "erd1qqqqqqqqqqqqqpgqcrqkv49gh7zlyereyxsrclpfl2rwrw3h0n4sq9cpus"
      )

    IO.inspect(contract)

    lp_total_supply = Decimal.new(1, raw_total_supply, -18)
    my_liquidity = Decimal.new(1, raw_liquidity, -18)

    # IO.inspect(lp_total_supply)
    # IO.inspect(my_liquidity)

    lp_percent = Decimal.div(my_liquidity, lp_total_supply)
    # IO.inspect(lp_percent)

    # IO.inspect(raw_total_supply)
    # IO.inspect(esdts)
  end

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
  test "get_lp_token_identifier" do
    {:ok, lp_token} = PairSc.get_lp_token_identifier(@wegld_ride_addr, @network)
    # IO.inspect(lp_token)
    assert lp_token == "EGLDRIDE-f8c488"
  end

  @tag :skip
  test "get_total_lp_token_supply" do
    rez = PairSc.get_total_lp_token_supply(@wegld_ride_addr, @network)
    IO.inspect(rez)
  end

  @tag :skip
  test "get_address_esdt" do
    result =
      REST.get_address_esdt(
        @network,
        "erd1eqkvd2r9h5uzyvj7kxs0s2g066axnpru7njr4c6fcxp53a6dcnyq38zp95"
      )

    IO.inspect(result)
  end

  @tag :skip
  test "lp_percent" do
    lp_percent_egld_ride
  end

  @tag :skip
  test "add_liquidity" do
    {:ok, pair} = PairSc.get_pair(@wegld_ride_addr, @network)

    transaction =
      PairSc.add_liquidity(
        @account,
        pair,
        100_000_000_000_000_000,
        97_000_000_000_000_000,
        10_289_630_063_883_110_167,
        9_980_941_161_966_616_861
      )

    {:ok, tx_hash} =
      transaction
      |> Transaction.prepare(@network)
      |> Transaction.sign()
      |> Elrondex.REST.post_transaction_send()

    IO.puts("tx_hash: #{tx_hash}")
  end

  @tag :skip
  test "remove_liquidity" do
    {:ok, pair} = PairSc.get_pair(@wegld_ride_addr, @network)

    first_min =
      (18_519_679_861_949_025_808_037 * 1_000_000_000_000_000_00 * 0.9 /
         14_607_757_112_398_009_698_838)
      |> round

    second_min =
      (1_161_882_943_364_706_117_788_613 * 1_000_000_000_000_000_00 * 0.9 /
         14_607_757_112_398_009_698_838)
      |> round

    tx = PairSc.remove_liquidity(@account, pair, 1_000_000_000_000_000_00, first_min, second_min)

    {:ok, tx_hash} =
      tx
      |> Transaction.prepare(@network)
      |> Transaction.sign()
      |> Elrondex.REST.post_transaction_send()

    IO.puts("tx_hash: #{tx_hash}")
  end
end
