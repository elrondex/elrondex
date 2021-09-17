defmodule Elrondex.WrapEgldTest do
  alias Elrondex.{Account, Transaction, Network, REST, ESDT}

  use ExUnit.Case

  @wrap_egld_address "erd1qqqqqqqqqqqqqpgqfj3z3k4vlq7dc2928rxez0uhhlq46s6p4mtqerlxhc"
  # Pair Contract
  @pair_egldbusd_address "erd1qqqqqqqqqqqqqpgq3gmttefd840klya8smn7zeae402w2esw0n4sm8m04f"
  # "BUSD-05b16f"
  # "WEGLD-88600a"
  # "EGLDBUSD-855259"

  # @tag :skip
  test "wrapEgld test" do
    devnet = Network.get(:devnet)

    mnemonic =
      "cost turn honey genre mercy reunion start lion snap box endorse horse cross destroy figure acid glue virtual taxi vital finish option inject inherit"

    address = "erd1ut3wf73j30x6l0suvn7dyequ6yex7lw08k8pup2l25027ee3xl2qenfh8m"

    value = "100000000000000000000"
    data = "wrapEgld"

    tx_hash =
      mnemonic
      |> Account.from_mnemonic()
      |> Transaction.transaction(@wrap_egld_address, value, data)
      |> Map.put(:gasLimit, 8_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "check wrapEgld" do
    devnet = Network.devnet()

    # My 
    address = "erd1ut3wf73j30x6l0suvn7dyequ6yex7lw08k8pup2l25027ee3xl2qenfh8m"
    # Example
    address = "erd1j9w8n9x9q8rly35t7k6a49956a775f08rjda0chs743gu7ypar9q802l4r"
    # 
    address = @wrap_egld_address
    address = @pair_egldbusd_address

    {:ok, esdt} = REST.get_address_esdt(devnet, address)
    IO.inspect(esdt)

    esdt
    |> Map.keys()
    |> Enum.join("\n")
    |> IO.inspect()
  end
end
