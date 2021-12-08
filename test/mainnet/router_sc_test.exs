defmodule Mainnet.RouterScTest do
  alias Elrondex.{ESDT, Account, Transaction, Network, REST}
  alias Elrondex.Sc.RouterSc

  use ExUnit.Case

  @router_address "erd1qqqqqqqqqqqqqpgqq66xk9gfr4esuhem3jru86wg5hvp33a62jps2fy57p"

  # @tag :skip
  test "get_all_pairs test" do
    mainnet = Network.get(:mainnet)

    rez_sc_call =
      @router_address
      |> RouterSc.get_all_pairs(mainnet)

    IO.inspect(rez_sc_call)
  end
end
