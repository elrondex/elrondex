defmodule Devnet.NetworkTest do
  alias Elrondex.{Network}

  use ExUnit.Case

  test "online devnet" do
    devnet = Network.get(:devnet)
    {:ok, devnet_load} = Network.new(:devnet) |> Network.load()
    assert devnet == devnet_load
    # IO.inspect(devnet)
    assert devnet.name == :devnet
    assert devnet.erd_chain_id == "D"
    assert devnet.endpoint.type == :proxy
    assert devnet.endpoint.url == "https://devnet-gateway.elrond.com"
    assert devnet.erd_denomination == 18
    assert devnet.erd_min_transaction_version == 1
    assert devnet.erd_num_shards_without_meta == 3
    # Load fields
    assert devnet.erd_gas_per_data_byte == 1500
    assert devnet.erd_gas_price_modifier == "0.01"
    assert devnet.erd_min_gas_limit == 50000
    assert devnet.erd_min_gas_price == 1_000_000_000
    assert devnet.erd_num_metachain_nodes == 58
    assert devnet.erd_num_nodes_in_shard == 58
    assert devnet.erd_rewards_top_up_gradient_point == "2000000000000000000000000"
    assert devnet.erd_round_duration == 6000
    assert devnet.erd_rounds_per_epoch == 1200
    # Dinamic fields
    # erd_latest_tag_software_version
    # erd_meta_consensus_group_size
    # erd_shard_consensus_group_size
    # erd_start_time
    # erd_top_up_factor
  end
end
