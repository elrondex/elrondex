if Mix.env() != :prod do
  defmodule Elrondex.Test.Bob do
    alias Elrondex.{Account, Transaction, Test}
    alias Elrondex.Sc.{PairSc}
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

    def transfer_1_egld_to_alice do
      tr = Transaction.transaction(account(), Alice.address(), 1_000_000_000_000_000_000)
      %{tr | nonce: 1, chainID: "T", gasLimit: 100, gasPrice: 10}
    end

    def swap_1_egld_to_min_100usdc do
      pair = Test.Utils.wegld_usdc_pair()
      account = Test.Bob.account()

      PairSc.swap_tokens_fixed_input(
        account,
        pair,
        pair.first_token,
        1000_000_000_000_000_000,
        pair.second_token,
        2 * 50 * 1_000_000
      )
    end
  end
end
