defmodule Elrondex.Test.Bob do
  alias Elrondex.{Account}

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
end
