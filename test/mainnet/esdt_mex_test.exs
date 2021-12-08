defmodule Mainnet.EsdtMexTest do
  alias Elrondex.{ESDT, Account, Transaction, Network, REST}

  use ExUnit.Case

  @mex_identifier "MEX-455c57"

  test "MEX token" do
    mainnet = Network.get(:mainnet)

    # ESDT
    esdt = %ESDT{identifier: @mex_identifier}
    {:ok, mex} = ESDT.get_rest_esdt(esdt, mainnet)
    IO.inspect(mex)

    assert mex.name == "MEX"
    assert mex.type == "FungibleESDT"
    assert mex.identifier == @mex_identifier
    assert mex.numDecimals == 18
    # Owner
    assert mex.account.address ==
             "erd1ss6u80ruas2phpmr82r42xnkd6rxy40g9jl69frppl4qez9w2jpsqj8x97"
  end
end
