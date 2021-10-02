defmodule Elrondex.ShardTest do
  alias Elrondex.{Shard, Block, Transaction, Network, REST, ESDT, Endpoint}
  alias Elrondex.Shard.ShardStatus

  use ExUnit.Case

  @tag :skip
  test "ShardStatus.from_status_payload" do
    shard_status_payload = """
    {
      "erd_current_round": 337537,
      "erd_epoch_number": 281,
      "erd_highest_final_nonce": 336268,
      "erd_nonce": 336272,
      "erd_nonce_at_epoch_start": 336219,
      "erd_nonces_passed_in_current_epoch": 53,
      "erd_round_at_epoch_start": 337484,
      "erd_rounds_passed_in_current_epoch": 53,
      "erd_rounds_per_epoch": 1200
    }
    """

    shard_status = Jason.decode!(shard_status_payload) |> ShardStatus.from_status_payload()

    IO.inspect(shard_status)

    assert shard_status.erd_current_round == 337_537
    assert shard_status.erd_epoch_number == 281
    assert shard_status.erd_highest_final_nonce == 336_268
    assert shard_status.erd_nonce == 336_272
    assert shard_status.erd_nonce_at_epoch_start == 336_219
    assert shard_status.erd_nonces_passed_in_current_epoch == 53
    assert shard_status.erd_round_at_epoch_start == 337_484
    assert shard_status.erd_rounds_passed_in_current_epoch == 53
    assert shard_status.erd_rounds_per_epoch == 1200
  end

  @tag :skip
  test "local ShardStatus.from_status_payload" do
    endpoint = Endpoint.new(:node, "http://127.0.0.1:8080/")
    my_node = %Network{name: :local, endpoint: endpoint}
    {:ok, payload} = REST.get_network_status(my_node)

    shard_status = payload |> ShardStatus.from_status_payload()
    IO.inspect(shard_status)
  end

  @tag :skip
  test "get_block_by_nonce" do
    endpoint = Endpoint.new(:node, "http://127.0.0.1:8080/")
    my_node = %Network{name: :local, endpoint: endpoint}
    # {:ok, payload} = REST.get_block_by_nonce(342_763, my_node, withTxs: true)
    {:ok, payload} = REST.get_block_by_nonce(342_763, my_node, withTxs: false)

    IO.inspect(payload)
    # payload = Map.put(payload, "accumulatedFees", "2223xx")

    block = Block.from_payload(payload)
    IO.inspect(block)
  end

  test "get_block_by_hash" do
    endpoint = Endpoint.new(:node, "http://127.0.0.1:8080/")
    my_node = %Network{name: :local, endpoint: endpoint}
    hash = "8835988deff389efda86e5dc47e96ce7242ec395849d6260f45b092d14b2dc3f"
    {:ok, payload} = REST.get_block_by_hash(hash, my_node, withTxs: true)
    # {:ok, payload} = REST.get_block_by_hash(hash, my_node, withTxs: false)

    IO.inspect(payload)
    # payload = Map.put(payload, "accumulatedFees", "2223xx")

    block = Block.from_payload(payload)
    IO.inspect(block)
  end
end
