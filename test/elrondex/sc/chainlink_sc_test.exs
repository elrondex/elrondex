defmodule Elrondex.Sc.ChainlinkScTest do
  alias Elrondex.{Account, Transaction, Network, REST}
  alias Elrondex.Sc.ChainlinkSc

  use ExUnit.Case

  def account() do
    mnemonic =
      "cost turn honey genre mercy reunion start lion snap box endorse horse cross destroy figure acid glue virtual taxi vital finish option inject inherit"

    # address = "erd1ut3wf73j30x6l0suvn7dyequ6yex7lw08k8pup2l25027ee3xl2qenfh8m"

    mnemonic
    |> Account.from_mnemonic()
  end

  @tag :skip
  test "latest_price_feed test" do
    devnet = Network.get(:devnet)

    tx_hash =
      account()
      |> ChainlinkSc.latest_price_feed("EGLD", "USD")
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "latest_price_feed test" do
    devnet = Network.get(:devnet)

    tx_hash =
      account()
      |> ChainlinkSc.latest_price_feed("EGLD", "USD")
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end
end
