defmodule Elrondex.CheckOnlineTransactionTest do
  alias Elrondex.{Account, Transaction, Network, REST}

  use ExUnit.Case

  test "sign and verify transaction" do
    mainnet = Network.mainnet()
    {:ok, config} = REST.get_network_config(mainnet)

    mainnet =
      mainnet
      |> Network.config(config)

    tx_hash = "eb06e3154318d81a33a7570226614d1350f2ea54e00e8afd96ff849280210070"

    {:ok, tx} = REST.get_transaction(mainnet, tx_hash)
    # IO.inspect(tx)
    # TODO fast load to Transaction record
    to_check = %Transaction{
      nonce: Map.get(tx, "nonce"),
      value: Map.get(tx, "value"),
      receiver: Map.get(tx, "receiver"),
      sender: Map.get(tx, "sender"),
      gasPrice: Map.get(tx, "gasPrice"),
      gasLimit: Map.get(tx, "gasLimit"),
      # we assume it is all the time nil
      data: Map.get(tx, "data"),
      chainID: mainnet.erd_chain_id,
      version: mainnet.erd_min_transaction_version,
      signature: Map.get(tx, "signature")
    }

    # IO.inspect(to_check)

    sender_account = Account.from_address(to_check.sender)
    assert Transaction.sign_verify(to_check, sender_account) == true
  end

  test "sign and verify transaction with data" do
    mainnet = Network.mainnet()
    {:ok, config} = REST.get_network_config(mainnet)

    mainnet =
      mainnet
      |> Network.config(config)

    tx_hash = "1f41005cf8cee55d6f977c93033c57a23c65899971c2da72a08cb9babf5f3ca4"

    {:ok, tx} = REST.get_transaction(mainnet, tx_hash)
    # IO.inspect(tx)
    # TODO fast load to Transaction record
    to_check = %Transaction{
      nonce: Map.get(tx, "nonce"),
      value: Map.get(tx, "value"),
      receiver: Map.get(tx, "receiver"),
      sender: Map.get(tx, "sender"),
      gasPrice: Map.get(tx, "gasPrice"),
      gasLimit: Map.get(tx, "gasLimit"),
      # we assume it is all the time not nil
      data: Base.decode64!(Map.get(tx, "data")),
      chainID: mainnet.erd_chain_id,
      version: mainnet.erd_min_transaction_version,
      signature: Map.get(tx, "signature")
    }

    IO.inspect(to_check)

    sender_account = Account.from_address(to_check.sender)
    assert Transaction.sign_verify(to_check, sender_account) == true
    assert Transaction.sign_verify(to_check) == true
  end
end
