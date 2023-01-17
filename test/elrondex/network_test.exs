defmodule Elrondex.NetworkTest do
  alias Elrondex.{Network}

  use ExUnit.Case

  def assert_network(network, network_name, erd_chain_id, endpoint_type, endpoint_url) do
    assert network.name == network_name
    assert network.erd_chain_id == erd_chain_id
    assert network.endpoint.type == endpoint_type
    assert network.endpoint.url == endpoint_url
    assert network.erd_denomination == 18
    assert network.erd_min_transaction_version == 1
    assert network.erd_num_shards_without_meta == 3
    assert network.erd_gas_per_data_byte == 1500
    assert network.erd_gas_price_modifier == "0.01"
    assert network.erd_min_gas_limit == 50000
    assert network.erd_min_gas_price == 1_000_000_000
  end

  def assert_mainnet(network) do
    assert_network(network, :mainnet, "1", :proxy, "https://gateway.multiversx.com")
  end

  def assert_testnet(network) do
    assert_network(network, :testnet, "T", :proxy, "https://testnet-gateway.multiversx.com")
  end

  def assert_devnet(network) do
    assert_network(network, :devnet, "D", :proxy, "https://devnet-gateway.multiversx.com")
  end

  test "default mainnet" do
    mainnet = Network.mainnet()
    assert_mainnet(mainnet)

    mainnet = Network.new(:mainnet)
    assert_mainnet(mainnet)

    mainnet = Network.new("mainnet")
    assert_mainnet(mainnet)

    mainnet = Network.new("mainnet", :node, "http://localhost:8080")
    assert_network(mainnet, :mainnet, "1", :node, "http://localhost:8080")
  end

  test "default testnet" do
    testnet = Network.testnet()
    assert_testnet(testnet)

    testnet = Network.new(:testnet)
    assert_testnet(testnet)

    testnet = Network.new("testnet")
    assert_testnet(testnet)

    testnet = Network.new("testnet", :node, "http://localhost:8080")
    assert_network(testnet, :testnet, "T", :node, "http://localhost:8080")
  end

  test "default devnet" do
    devnet = Network.devnet()
    assert_devnet(devnet)

    devnet = Network.new(:devnet)
    assert_devnet(devnet)

    devnet = Network.new("devnet")
    assert_devnet(devnet)

    devnet = Network.new("devnet", :node, "http://localhost:8080")
    assert_network(devnet, :devnet, "D", :node, "http://localhost:8080")
  end
end
