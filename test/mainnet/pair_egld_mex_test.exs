defmodule Mainnet.PairEgldMexTest do
  alias Elrondex.{ESDT, Account, Transaction, Network, REST}
  alias Elrondex.Sc.PairSc

  use ExUnit.Case
  @moduletag network: :mainnet

  @pair_egldmex_address "erd1qqqqqqqqqqqqqpgqa0fsfshnff4n76jhcye6k7uvd7qacsq42jpsp6shh2"
  @wegld_identifier "WEGLD-bd4d79"
  @mex_identifier "MEX-455c57"

  test "get egldmex pair" do
    mainnet = Network.get(:mainnet)
    {:ok, pair} = PairSc.get_pair(@pair_egldmex_address, mainnet)
    # IO.inspect(pair)
    assert pair.first_token == @wegld_identifier
    assert pair.second_token == @mex_identifier
  end

  test "get_reserve WEGLD" do
    mainnet = Network.get(:mainnet)
    {:ok, reserve} = PairSc.get_reserve(@pair_egldmex_address, @wegld_identifier, mainnet)
    IO.puts("WEGLD reserve: #{reserve}")
  end

  test "get_reserve MEX" do
    mainnet = Network.get(:mainnet)
    {:ok, reserve} = PairSc.get_reserve(@pair_egldmex_address, @mex_identifier, mainnet)
    IO.puts("MEX reserve: #{reserve}")
  end

  test "get esdts from egldmex contract" do
    mainnet = Network.get(:mainnet)
    {:ok, esdts} = REST.get_address_esdt(mainnet, @pair_egldmex_address)
    # IO.inspect(esdts)
  end

  test "get_state" do
    mainnet = Network.get(:mainnet)
    {:ok, state} = PairSc.get_state(@pair_egldmex_address, mainnet)
    IO.inspect(state)
  end

  test "get_lp_token_identifier" do
    mainnet = Network.get(:mainnet)
    {:ok, lp_token} = PairSc.get_lp_token_identifier(@pair_egldmex_address, mainnet)
    # IO.inspect(lp_token)
    assert lp_token == "EGLDMEX-0be9e5"
  end

  test "get_first_token_id" do
    mainnet = Network.get(:mainnet)
    {:ok, first_token} = PairSc.get_first_token_id(@pair_egldmex_address, mainnet)
    # IO.inspect(first_token)
    assert first_token == @wegld_identifier
  end

  test "get_router_managed_address" do
    mainnet = Network.get(:mainnet)
    {:ok, router_address} = PairSc.get_router_managed_address(@pair_egldmex_address, mainnet)
    # IO.inspect(router_address)
  end

  test "get_router_owner_managed_address" do
    mainnet = Network.get(:mainnet)

    {:ok, router_owner_address} =
      PairSc.get_router_owner_managed_address(@pair_egldmex_address, mainnet)

    # IO.inspect(router_owner_address)
  end

  test "get_amount_in" do
    mainnet = Network.get(:mainnet)
    {:ok, pair} = PairSc.get_pair(@pair_egldmex_address, mainnet)

    {:ok, amount_in} =
      PairSc.get_amount_in(
        pair,
        @wegld_identifier,
        # 1 EGDL
        1_000_000_000_000_000_000,
        mainnet
      )

    IO.inspect(amount_in)
    # 330911 522143 072374 112067 MEX
    # Rate 329918.5984
  end

  test "get_amount_out" do
    mainnet = Network.get(:mainnet)
    {:ok, pair} = PairSc.get_pair(@pair_egldmex_address, mainnet)

    {:ok, amount_out} =
      PairSc.get_amount_out(
        pair,
        @wegld_identifier,
        # 1 EGDL
        1_000_000_000_000_000_000,
        mainnet
      )

    IO.inspect(amount_out)
    # 328928_596649_678205_847182 MEX
    # Rate 329918.5984
  end

  test "get_total_fee_percent" do
    mainnet = Network.get(:mainnet)
    {:ok, total_fee_percent} = PairSc.get_total_fee_percent(@pair_egldmex_address, mainnet)
    IO.inspect(total_fee_percent)
    # 300     -> 0.3 %
    #   1_000 ->   1%
    # 100_000 -> 100%
  end

  test "get_special_fee" do
    mainnet = Network.get(:mainnet)
    {:ok, special_fee} = PairSc.get_special_fee(@pair_egldmex_address, mainnet)
    IO.inspect(special_fee)
    # 50
    # 0.05 % ? MEX burn back ?
  end
end
