defmodule Mainnet.PairEgldUsdcTest do
  alias Elrondex.{ESDT, Account, Transaction, Network, REST}
  alias Elrondex.Sc.PairSc

  use ExUnit.Case
  @moduletag network: :mainnet

  @pair_egldusdc_address "erd1qqqqqqqqqqqqqpgqeel2kumf0r8ffyhth7pqdujjat9nx0862jpsg2pqaq"
  @wegld_identifier "WEGLD-bd4d79"
  @usdc_identifier "USDC-c76f1f"

  test "get egldusdc pair" do
    mainnet = Network.get(:mainnet)
    {:ok, pair} = PairSc.get_pair(@pair_egldusdc_address, mainnet)
    # IO.inspect(pair)
    assert pair.first_token == @wegld_identifier
    assert pair.second_token == @usdc_identifier
  end
end
