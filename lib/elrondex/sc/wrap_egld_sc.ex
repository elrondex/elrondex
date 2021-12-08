defmodule Elrondex.Sc.WrapEgldSc do
  alias Elrondex.{Transaction, Account, REST, ESDT, Network, Sc}

  @doc """
  Return wrapped ESDT token id associated to native EGLD token by SC   
  """
  # We can implement this as config or cached/genserver
  def wrapped_egld_token_id() do
    # PROD
    "WEGLD-bd4d79"
    # TEST
    # "WEGLD-7fbb90"
  end

  @doc """
  Return wrapped ESDT token id    
  """
  # We can implement this as config or cached/genserver
  def wrapped_egld_address() do
    # PROD
    "erd1qqqqqqqqqqqqqpgqhe8t5jewej70zupmh44jurgn29psua5l2jps3ntjj3"
    # TEST
    # "erd1qqqqqqqqqqqqqpgqd77fnev2sthnczp2lnfx0y5jdycynjfhzzgq6p3rax"
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
    |> Map.put(:gasLimit, 18_000_000)
  end

  def get_locked_egld_balance(wrapped_egld_address, %Network{} = network, opts \\ []) do
    wrapped_egld_address
    |> Sc.view_map_call("getLockedEgldBalance")
    |> REST.post_vm_values_int(network)
  end

  def get_wrapped_egld_token_id(wrapped_egld_address, %Network{} = network, opts \\ []) do
    wrapped_egld_address
    |> Sc.view_map_call("getWrappedEgldTokenId")
    |> REST.post_vm_values_string(network)
  end
end
