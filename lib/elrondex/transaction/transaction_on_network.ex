defmodule Elrondex.Transaction.TransactionOnNetwork do
  alias Elrondex.Transaction.{TransactionOnNetwork}
  alias Elrondex.{Struct}

  # TODO hash, smartContractResults
  # TODO NotarizedAtSourceInMetaHash
  defstruct blockHash: nil,
            blockNonce: nil,
            data: nil,
            destinationShard: nil,
            epoch: nil,
            gasLimit: nil,
            gasPrice: nil,
            hyperblockHash: nil,
            hyperblockNonce: nil,
            miniblockHash: nil,
            miniblockType: nil,
            nonce: nil,
            notarizedAtDestinationInMetaHash: nil,
            notarizedAtDestinationInMetaNonce: nil,
            notarizedAtSourceInMetaNonce: nil,
            receiver: nil,
            round: nil,
            sender: nil,
            signature: nil,
            sourceShard: nil,
            status: nil,
            timestamp: nil,
            type: nil,
            value: nil

  # [struct_field, payload_field, type, require, since_version, default]
  def struct_fields() do
    [
      {:blockHash, "blockHash", :string, true, 0, nil},
      {:blockNonce, "blockNonce", :integer, true, 0, 0},
      {:data, "data", :string, false, 0, nil},
      {:destinationShard, "destinationShard", :integer, true, 0, 0},
      {:epoch, "epoch", :integer, true, 0, 0},
      # gasLimit may be missing for SC call 
      {:gasLimit, "gasLimit", :integer, false, 0, nil},
      {:gasPrice, "gasPrice", :integer, true, 0, 0},
      {:hyperblockHash, "hyperblockHash", :string, true, 0, nil},
      {:hyperblockNonce, "hyperblockNonce", :integer, true, 0, 0},
      {:miniblockHash, "miniblockHash", :string, true, 0, nil},
      {:miniblockType, "miniblockType", :string, true, 0, nil},
      {:nonce, "nonce", :integer, true, 0, 0},
      {:notarizedAtDestinationInMetaHash, "notarizedAtDestinationInMetaHash", :string, true, 0,
       nil},
      {:notarizedAtDestinationInMetaNonce, "notarizedAtDestinationInMetaNonce", :integer, true, 0,
       0},
      {:notarizedAtSourceInMetaNonce, "notarizedAtSourceInMetaNonce", :integer, true, 0, 0},
      {:receiver, "receiver", :string, true, 0, nil},
      {:round, "round", :integer, true, 0, 0},
      {:sender, "sender", :string, true, 0, nil},
      {:signature, "signature", :string, false, 0, nil},
      {:sourceShard, "sourceShard", :integer, true, 0, 0},
      {:status, "status", :string, true, 0, nil},
      {:timestamp, "timestamp", :integer, true, 0, 0},
      {:type, "type", :string, true, 0, nil},
      {:value, "value", :integer, true, 0, 0}
    ]
  end

  def from_payload(payload, version \\ 0) when is_map(payload) do
    Struct.struct_load(%TransactionOnNetwork{}, payload, struct_fields(), version)
  end
end
