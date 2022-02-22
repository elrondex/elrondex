defmodule GetFeeStateTest do
  use ExUnit.Case
  alias Elrondex.{Network}
  alias Elrondex.Sc.{PairSc}

  @mainnet Network.get(:mainnet)

  # @tag :skip
  test "get_fee_state wegld/usdc" do
    pair_addr = "erd1qqqqqqqqqqqqqpgqeel2kumf0r8ffyhth7pqdujjat9nx0862jpsg2pqaq"
    {:ok, state} = PairSc.get_fee_state(pair_addr, @mainnet)
    #IO.inspect(state)
    assert state == :active
  end
end
