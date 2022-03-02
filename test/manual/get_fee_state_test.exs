defmodule GetFeeStateTest do
  use ExUnit.Case
  alias Elrondex.{Network}
  alias Elrondex.Sc.{PairSc, RouterSc}

  @mainnet Network.get(:mainnet)
  @router_addr "erd1qqqqqqqqqqqqqpgqq66xk9gfr4esuhem3jru86wg5hvp33a62jps2fy57p"

  @tag :skip
  test "get router address" do
    # wegld/usdc pair
    pair_addr = "erd1qqqqqqqqqqqqqpgqeel2kumf0r8ffyhth7pqdujjat9nx0862jpsg2pqaq"

    router_addr = PairSc.get_router_managed_address(pair_addr, @mainnet)
    IO.inspect(router_addr)
  end

  @tag :skip
  test "get all pairs" do
    addr = RouterSc.get_all_pairs(@router_addr, @mainnet)
    IO.inspect(addr)
  end

  @tag :skip
  test "get_fee_state wegld/usdc" do
    pair_addr = "erd1qqqqqqqqqqqqqpgqeel2kumf0r8ffyhth7pqdujjat9nx0862jpsg2pqaq"
    {:ok, state} = PairSc.get_fee_state(pair_addr, @mainnet)
    IO.inspect(state)
  end

  @tag :skip
  test "get_fee_state wegld/ride" do
    pair_addr = "erd1qqqqqqqqqqqqqpgqmcy3q34wpppkuw9wxkvtewmrvw374fuf2jpsr74zvl"
    {:ok, state} = PairSc.get_fee_state(pair_addr, @mainnet)
    IO.inspect(state)
  end

  @tag :skip
  test "check all pair states" do
    {:ok, addr}  = RouterSc.get_all_pairs(@router_addr, @mainnet)
    x = Enum.map(addr, fn %{address: a, first_token: b, second_token: c} -> [a, b, c, PairSc.get_fee_state(a, @mainnet)] end)
    IO.inspect(x)
  end
end
