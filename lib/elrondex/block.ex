defmodule Elrondex.Block do
  alias Elrondex.{Block, Struct}

  defstruct accumulatedFees: nil,
            developerFees: nil,
            epoch: nil,
            hash: nil,
            # miniBlocks: nil,
            nonce: nil,
            numTxs: nil,
            prevBlockHash: nil,
            round: nil,
            shard: nil,
            status: nil,
            timestamp: nil

  # [struct_field, payload_field, type, require, since_version, default]
  def struct_fields() do
    [
      {:accumulatedFees, "accumulatedFees", :integer, true, 0, 0},
      {:developerFees, "developerFees", :integer, true, 0, 0},
      {:epoch, "epoch", :integer, true, 0, 0},
      {:hash, "hash", :string, true, 0, nil},
      {:nonce, "nonce", :integer, true, 0, 0},
      {:numTxs, "numTxs", :integer, true, 0, 0},
      {:prevBlockHash, "prevBlockHash", :string, true, 0, nil},
      {:round, "round", :integer, true, 0, 0},
      {:shard, "shard", :integer, true, 0, 0},
      {:status, "status", :string, true, 0, nil},
      {:timestamp, "timestamp", :integer, true, 0, 0}
    ]
  end

  def from_payload(payload, version \\ 0) when is_map(payload) do
    Struct.struct_load(%Block{}, payload, struct_fields(), version)
  end
end
