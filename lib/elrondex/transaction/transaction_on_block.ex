defmodule Elrondex.Transaction.TransactionOnBlock do
  alias Elrondex.Transaction.{TransactionOnBlock}
  alias Elrondex.{Struct}

  defstruct data: nil,
            destinationShard: nil,
            epoch: nil,
            # gasLimit: nil,
            gasPrice: nil,
            hash: nil,
            miniblockHash: nil,
            miniblockType: nil,
            nonce: nil,
            originalTransactionHash: nil,
            previousTransactionHash: nil,
            receiver: nil,
            sender: nil,
            sourceShard: nil,
            status: nil,
            type: nil,
            value: nil

  # [struct_field, payload_field, type, require, since_version, default]
  def struct_fields() do
    [
      {:data, "data", :string, false, 0, nil},
      {:destinationShard, "destinationShard", :integer, true, 0, 0},
      {:epoch, "epoch", :integer, true, 0, 0},
      # {:gasLimit, "gasLimit", :integer, true, 0, 0},
      {:gasPrice, "gasPrice", :integer, true, 0, 0},
      {:hash, "hash", :string, true, 0, nil},
      {:miniblockHash, "miniblockHash", :string, true, 0, nil},
      {:miniblockType, "miniblockType", :string, true, 0, nil},
      {:nonce, "nonce", :integer, true, 0, 0},
      {:originalTransactionHash, "originalTransactionHash", :string, true, 0, nil},
      {:previousTransactionHash, "previousTransactionHash", :string, true, 0, nil},
      {:receiver, "receiver", :string, true, 0, nil},
      {:sender, "sender", :string, true, 0, nil},
      {:sourceShard, "sourceShard", :integer, true, 0, 0},
      {:status, "status", :string, true, 0, nil},
      {:type, "type", :string, true, 0, nil},
      {:value, "value", :integer, true, 0, 0}
    ]
  end

  def from_payload(payload, version \\ 0) when is_map(payload) do
    Struct.struct_load(%TransactionOnBlock{}, payload, struct_fields(), version)
  end
end
