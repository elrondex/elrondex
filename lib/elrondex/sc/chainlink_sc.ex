defmodule Elrondex.Sc.ChainlinkSc do
  alias Elrondex.{Sc, Transaction, Account, REST, ESDT}

  @doc """
  Return Chainlink SC address 
  """
  # We can implement this as config or cached/genserver
  # TODO Why we have one contract per shard ?
  def address() do
    "erd1qqqqqqqqqqqqqpgqsj7m22r09nu8seqmdrcmn5f6038qqdq7707qvs0pe0"
  end

  @doc """
  Return transaction associated with the account that 
  call Chainlink SC for latest price feed asociated to 
  asset1/asset2

  In order to be ready for blockchain transaction need to be 
  prepared and signed
  """
  def latest_price_feed(%Account{} = account, asset1, asset2) do
    data = Sc.data_call("latestPriceFeed", [asset1, asset2])

    account
    |> Transaction.transaction(address(), 0, data)
    |> Map.put(:gasLimit, 50_000_000)
  end

  @doc """
  Return transaction associated with the account that 
  call Chainlink SC to get all the price feeds for 
  all the available assets

  In order to be ready for blockchain transaction need to be 
  prepared and signed
  """
  def latest_round_data(%Account{} = account) do
    account
    |> Transaction.transaction(address(), 0, "latestRoundData")
    |> Map.put(:gasLimit, 8_000_000)
  end
end
