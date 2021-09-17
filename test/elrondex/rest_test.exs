defmodule Elrondex.RESTTest do
  alias Elrondex.{Network, REST}

  use ExUnit.Case

  test "test get_network_config on mainnet" do
    mainnet = Network.mainnet()
    {:ok, config} = REST.get_network_config(mainnet)
    # IO.inspect(config)    
    mainnet = Network.config(mainnet, config)
    # IO.inspect(mainnet)    
    assert mainnet.erd_chain_id == "1"
  end

  test "test get_network_config on testnet" do
    testnet = Network.testnet()
    {:ok, config} = REST.get_network_config(testnet)
    # IO.inspect(config)
    testnet = Network.config(testnet, config)
    # IO.inspect(testnet)
    assert testnet.erd_chain_id == "T"
  end

  test "test get_network_config on devnet" do
    devnet = Network.devnet()
    assert devnet.erd_chain_id == nil
    {:ok, config} = REST.get_network_config(devnet)
    IO.inspect(config)
    devnet = Network.config(devnet, config)
    IO.inspect(devnet)
    assert devnet.erd_chain_id == "D"
  end
end
