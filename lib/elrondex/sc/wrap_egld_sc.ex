defmodule Elrondex.Sc.WrapEgldSc do
  alias Elrondex.{Transaction, Account, REST, ESDT}

  @doc """
  Return wrapped ESDT token id associated to native EGLD token by SC   
  """
  # We can implement this as config or cached/genserver
  def wrapped_egld_token_id() do
    "WEGLD-073650"
  end

  @doc """
  Return wrapped ESDT token id    
  """
  # We can implement this as config or cached/genserver
  def wrapped_egld_address() do
    "erd1qqqqqqqqqqqqqpgqfj3z3k4vlq7dc2928rxez0uhhlq46s6p4mtqerlxhc"
  end

  @doc """
  Return transaction associated with the account that 
  wrap native EGLD token to wrapped ESDT token by calling CS

  In order to be ready for blockchain transaction need to be 
  prepared and signed 
  """
  def wrap_egld(%Account{} = account, value) when is_integer(value) do
    account
    |> Transaction.transaction(wrapped_egld_address(), value, "wrapEgld")
    |> Map.put(:gasLimit, 8_000_000)
  end

  @doc """
  Return transaction associated with the account that 
  swap wrapped ESDT token to native EGLD token by calling CS

  Transaction is simple ESDT token transfer from account to SC with 
  aditional argument `unwrapEgld`

  In order to be ready for blockchain transaction need to be 
  prepared and signed 
  """
  def unwrap_egld(%Account{} = account, value) when is_integer(value) do
    esdt = %ESDT{identifier: wrapped_egld_token_id()}

    account
    |> ESDT.transfer(wrapped_egld_address(), esdt, value, ["unwrapEgld"])
    |> Map.put(:gasLimit, 8_000_000)
  end
end
