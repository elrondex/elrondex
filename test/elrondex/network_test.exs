defmodule Elrondex.NetworkTest do
  alias Elrondex.{Network}

  use ExUnit.Case

  test "default mainnet" do
    mainnet = Network.mainnet()
    assert mainnet.name == :mainnet
  end

  test "default testnet" do
    mainnet = Network.testnet()
    assert mainnet.name == :testnet
  end
end
