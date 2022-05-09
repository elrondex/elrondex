defmodule Mainnet.EsdtUsdcTest do
  alias Elrondex.{ESDT, Network}

  use ExUnit.Case
  require Logger
  @moduletag network: :mainnet

  @usdc_identifier "USDC-c76f1f"

  test "USDC token" do
    mainnet = Network.get(:mainnet)

    # ESDT
    esdt = %ESDT{identifier: @usdc_identifier}
    {:ok, usdc} = ESDT.get_rest_esdt(esdt, mainnet)

    Logger.debug(inspect(usdc))

    assert usdc.name == "WrappedUSDC"
    assert usdc.type == "FungibleESDT"
    assert usdc.identifier == @usdc_identifier
    assert usdc.numDecimals == 6
    # Owner
    assert usdc.account.address ==
             "erd1ss6u80ruas2phpmr82r42xnkd6rxy40g9jl69frppl4qez9w2jpsqj8x97"
  end
end
