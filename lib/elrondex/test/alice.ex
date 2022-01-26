defmodule Elrondex.Test.Alice do
  alias Elrondex.{Account}
  @mnemonic ["pizza" | List.duplicate("flower", 23)]

  def account do
    Account.from_mnemonic(@mnemonic)
  end

end
