defmodule Elrondex.RESTTest do
  alias Elrondex.{Network, REST}

  use ExUnit.Case

  test "test get_network_config on mainnet" do
    mainnet = Network.mainnet()
    assert mainnet.erd_chain_id == "1"
    {:ok, config} = REST.get_network_config(mainnet)
    mainnet = Network.config(mainnet, config)
    assert mainnet.erd_chain_id == "1"
  end

  test "test get_network_config on testnet" do
    testnet = Network.testnet()
    assert testnet.erd_chain_id == "T"
    {:ok, config} = REST.get_network_config(testnet)
    testnet = Network.config(testnet, config)
    assert testnet.erd_chain_id == "T"
  end

  test "test get_network_config on devnet" do
    devnet = Network.devnet()
    assert devnet.erd_chain_id == "D"
    {:ok, config} = REST.get_network_config(devnet)
    devnet = Network.config(devnet, config)
    assert devnet.erd_chain_id == "D"
  end
end
