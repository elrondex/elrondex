defmodule Elrondex.Test.Bob do
  alias Elrondex.{Account, Transaction}

  @mnemonic ["flower" | List.duplicate("pizza", 23)]
  @reciver [11| List.duplicate("11", 12)]
  @value 1_000_000_000

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
  def send_1_egld_to_alice do
    Transaction.transaction(account(), Alice.account(),1_000_000_000_000_000_000)
  end
end
