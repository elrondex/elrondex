defmodule Mainnet.NetworkTest do
  alias Elrondex.{Network}

  use ExUnit.Case
  require Logger
  @moduletag network: :mainnet

  test "online mainnet" do
    mainnet = Network.get(:mainnet)
    {:ok, mainnet_load} = Network.new(:mainnet) |> Network.load()
    assert mainnet == mainnet_load

    # TODO pretty debug log
    # IO.inspect(mainnet)
    Logger.debug(inspect(mainnet))
    # IO.puts(inspect(mainnet))

    assert mainnet.name == :mainnet
    assert mainnet.erd_chain_id == "1"
    assert mainnet.endpoint.type == :proxy
    assert mainnet.endpoint.url == "https://gateway.multiversx.com"
    assert mainnet.erd_denomination == 18
    assert mainnet.erd_min_transaction_version == 1
    assert mainnet.erd_num_shards_without_meta == 3
    # Load fields
    assert mainnet.erd_gas_per_data_byte == 1500
    assert mainnet.erd_gas_price_modifier == "0.01"
    assert mainnet.erd_min_gas_limit == 50000
    assert mainnet.erd_min_gas_price == 1_000_000_000
    assert mainnet.erd_num_metachain_nodes == 400
    assert mainnet.erd_num_nodes_in_shard == 400
    assert mainnet.erd_rewards_top_up_gradient_point == "2000000000000000000000000"
    assert mainnet.erd_round_duration == 6000
    assert mainnet.erd_rounds_per_epoch == 14400
    # Dinamic fields
    # erd_latest_tag_software_version
    # erd_meta_consensus_group_size
    # erd_shard_consensus_group_size
    # erd_start_time
    # erd_top_up_factor
  end
end
