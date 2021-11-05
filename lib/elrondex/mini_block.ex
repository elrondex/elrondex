defmodule Elrondex.MiniBlock do
  alias Elrondex.{MiniBlock, TransactionOnBlock, Struct}
  alias Elrondex.Transaction.TransactionOnBlock

  defstruct destinationShard: nil,
            hash: nil,
            sourceShard: nil,
            type: nil,
            transactions: []

  # [struct_field, payload_field, type, require, since_version, default]
  def struct_fields() do
    [
      {:destinationShard, "destinationShard", :integer, true, 0, 0},
      {:hash, "hash", :string, true, 0, nil},
      {:sourceShard, "sourceShard", :integer, true, 0, 0},
      {:type, "type", :string, true, 0, nil},
      {:transactions, "transactions", :list, true, 0, &TransactionOnBlock.from_payload/2}
    ]
  end

  def from_payload(payload, version \\ 0) when is_map(payload) do
    Struct.struct_load(%MiniBlock{}, payload, struct_fields(), version)
  end
end
