defmodule Elrondex.Sc.RouterScTest do
  alias Elrondex.{Account, Transaction, Network, REST, Pair}
  alias Elrondex.Sc.RouterSc

  use ExUnit.Case

  @router_address "erd1qqqqqqqqqqqqqpgqnhlmwqvpt0r3uurlyg2p2f4q33q05cut0n4s325q26"

  @tag :skip
  test "get_all_pairs_addresses test" do
    testnet = Network.get(:testnet)

    rez_sc_call =
      @router_address
      |> RouterSc.get_all_pairs_addresses(testnet)

    IO.inspect(rez_sc_call)
  end

  @tag :skip
  test "get_all_pairs test" do
    testnet = Network.get(:testnet)

    rez_sc_call =
      @router_address
      |> RouterSc.get_all_pairs(testnet)

    IO.inspect(rez_sc_call)
  end
end
