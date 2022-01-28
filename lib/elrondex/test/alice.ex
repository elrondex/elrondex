defmodule Elrondex.Test.Alice do
  alias Elrondex.{Account, Transaction}
  @mnemonic ["pizza" | List.duplicate("flower", 23)]

  def account do
    Account.from_mnemonic(@mnemonic)
  end
  def address do
    account().address
  end

end
