defmodule Mainnet.EsdtWegldTest do
  alias Elrondex.{ESDT, Account, Transaction, Network, REST}

  use ExUnit.Case

  @wegld_identifier "WEGLD-bd4d79"

  test "WEGLD token" do
    mainnet = Network.get(:mainnet)

    # ESDT
    esdt = %ESDT{identifier: @wegld_identifier}
    {:ok, wegld} = ESDT.get_rest_esdt(esdt, mainnet)
    IO.inspect(wegld)

    assert wegld.name == "WrappedEGLD"
    assert wegld.type == "FungibleESDT"
    assert wegld.identifier == @wegld_identifier
    assert wegld.numDecimals == 18
    # Owner
    assert wegld.account.address ==
             "erd1ss6u80ruas2phpmr82r42xnkd6rxy40g9jl69frppl4qez9w2jpsqj8x97"
  end
end
