defmodule Elrondex.Test.Alice do
  alias Elrondex.{Account}

  @mnemonic ["flower" | List.duplicate("pizza", 23)]

  def account do
      Account.from_mnemonic(@mnemonic)
  end

end
