if Mix.env() != :prod do
  defmodule Elrondex.Test.Bob do
    alias Elrondex.{Account, Transaction}
    alias Elrondex.Test.Alice

    @mnemonic ["flower" | List.duplicate("pizza", 23)]

    def account do
      Account.from_mnemonic(@mnemonic)
    end

    def mnemonic do
      @mnemonic
    end

    def private_key do
      account().private_key
    end

    def public_key do
      account().public_key
    end

    def address do
      account().address
    end

    def hex_public_key do
      account() |> Account.hex_public_key()
    end

    def hex_private_key do
      account() |> Account.hex_private_key()
    end

    def transfer_1_egld_to_alice do
      tr = Transaction.transaction(account(), Alice.address(), 1_000_000_000_000_000_000)
      %{tr | nonce: 1, chainID: "T", gasLimit: 100, gasPrice: 10}
    end
  end
end
