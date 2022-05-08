defmodule Testnet.NetworkTest do
  alias Elrondex.{NetworkTest}
  alias Elrondex.{Network, REST}

  use ExUnit.Case

  test "online testnet" do
    testnet = Network.get(:testnet)
    {:ok, testnet_load} = Network.new(:testnet) |> Network.load()
    assert testnet = testnet_load
    IO.inspect(testnet)
    assert testnet.name == :testnet
    assert testnet.erd_chain_id == "T"
    assert testnet.endpoint.type == :proxy
    assert testnet.endpoint.url == "https://testnet-gateway.elrond.com"
    assert testnet.erd_denomination == 18
    assert testnet.erd_min_transaction_version == 1
    assert testnet.erd_num_shards_without_meta == 3
    # Load fields
    assert testnet.erd_gas_per_data_byte == 1500
    assert testnet.erd_gas_price_modifier == "0.01"
    assert testnet.erd_min_gas_limit == 50000
    assert testnet.erd_min_gas_price == 1_000_000_000
    assert testnet.erd_num_metachain_nodes == 400
    assert testnet.erd_num_nodes_in_shard == 400
    assert testnet.erd_rewards_top_up_gradient_point == "2000000000000000000000000"
    assert testnet.erd_round_duration == 6000
    assert testnet.erd_rounds_per_epoch == 1200
    # Dinamic fields
    # erd_latest_tag_software_version
    # erd_meta_consensus_group_size
    # erd_shard_consensus_group_size
    # erd_start_time
    # erd_top_up_factor
  end
end
