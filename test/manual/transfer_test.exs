defmodule Manual.TransferTest do
  use ExUnit.Case
  doctest Elrondex.Sc.PairSc

  alias Elrondex.{Network, Account, REST, Transaction, Test, ESDT}
  alias Elrondex.Sc.{PairSc}

  @mnemonic "grace ribbon fix surge genuine vote food soccer fringe entire energy frost bind rather sail finish enhance flavor hurdle sudden warm isolate coyote loan"
  @account Account.from_mnemonic(@mnemonic)

  @network Network.get(:testnet)

  @tag :skip
  test "multi_esdt_nft_transfer 2 tokens" do
    transaction =
      ESDT.multi_esdt_nft_transfer(
        @account,
        "erd1k6h49sesy2aqazyexfs7ylmzhk8s0rxv8qn4mw6v3akh9ywkn66qnswe70",
        "RIDE-cfdd23",
        1_000_000_000_000_000_00,
        "WEGLD-584d96",
        1_000_000_000_000_000_00
      )

    {:ok, tx_hash} =
      transaction
      |> Transaction.prepare(@network)
      |> Transaction.sign()
      |> Elrondex.REST.post_transaction_send()

    IO.puts("tx_hash: #{tx_hash}")
  end

  @tag :skip
  test "multi_esdt_nft_transfer 3 tokens" do
    transaction =
      ESDT.multi_esdt_nft_transfer(
        @account,
        "erd1k6h49sesy2aqazyexfs7ylmzhk8s0rxv8qn4mw6v3akh9ywkn66qnswe70",
        [
          {"RIDE-cfdd23", 1_000_000_000_000_000_00},
          {"USDC-ebc075", 1_000_00},
          {"WEGLD-584d96", 1_000_000_000_000_000_00}
        ]
      )

    {:ok, tx_hash} =
      transaction
      |> Transaction.prepare(@network)
      |> Transaction.sign()
      |> Elrondex.REST.post_transaction_send()

    IO.puts("tx_hash: #{tx_hash}")
  end
end
