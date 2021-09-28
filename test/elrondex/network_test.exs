defmodule Elrondex.NetworkTest do
  alias Elrondex.{Network}

  use ExUnit.Case

  test "default mainnet" do
    mainnet = Network.mainnet()
    # mainnet = Network.get(:mainnet)
    assert mainnet.name == :mainnet
    assert mainnet.erd_chain_id == "1"
  end

  test "default testnet" do
    testnet = Network.testnet()
    # testnet = Network.get(:testnet)
    assert testnet.name == :testnet
    assert testnet.erd_chain_id == "T"
  end

  test "default devnet" do
    devnet = Network.devnet()
    # devnet = Network.get(:devnet)
    assert devnet.name == :devnet
    assert devnet.erd_chain_id == "D"
  end
end
