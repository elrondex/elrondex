defmodule Elrondex.Sc.PairSc do
  alias Elrondex.{Sc, Transaction, Account, REST, ESDT, Pair, Network}

  def accept_esdt_payment(%Account{} = account, %Pair{} = pair, token_identifier, value)
      when is_binary(token_identifier) and is_integer(value) do
    esdt = %ESDT{identifier: Pair.token_identifier(pair, token_identifier)}

    ESDT.transfer(account, pair.address, esdt, value, ["acceptEsdtPayment"])
    |> Map.put(:gasLimit, 100_000_000)
  end

  def temporary_funds(%Account{} = account, %Pair{} = pair, token_identifier) do
    temporary_funds(account, pair, account.public_key, token_identifier)
  end

  def temporary_funds(%Account{} = account, %Pair{} = pair, caller, token_identifier) do
    esdt = %ESDT{identifier: Pair.token_identifier(pair, token_identifier)}
    data = Sc.data_call("getTemporaryFunds", [caller, esdt.identifier])

    Transaction.transaction(account, pair.address, 0, data)
    |> Map.put(:gasLimit, 100_000_000)
  end

  def get_equivalent(%Account{} = account, %Pair{} = pair, token_identifier, value) do
    esdt = %ESDT{identifier: Pair.token_identifier(pair, token_identifier)}
    data = Sc.data_call("getEquivalent", [esdt.identifier, value])

    Transaction.transaction(account, pair.address, 0, data)
    |> Map.put(:gasLimit, 100_000_000)
  end

  def get_amount_in(%Account{} = account, %Pair{} = pair, token_wanted_identifier, value_wanted) do
    esdt = %ESDT{identifier: Pair.token_identifier(pair, token_wanted_identifier)}
    data = Sc.data_call("getAmountIn", [esdt.identifier, value_wanted])

    Transaction.transaction(account, pair.address, 0, data)
    |> Map.put(:gasLimit, 100_000_000)
  end

  def get_amount_out(%Account{} = account, %Pair{} = pair, token_in_identifier, value_in) do
    esdt = %ESDT{identifier: Pair.token_identifier(pair, token_in_identifier)}
    data = Sc.data_call("getAmountOut", [esdt.identifier, value_in])

    Transaction.transaction(account, pair.address, 0, data)
    |> Map.put(:gasLimit, 100_000_000)
  end

  def get_first_token_id(pair_address, %Network{} = network, opts \\ []) do
    get_pair_token_id(pair_address, network, "getFirstTokenId", opts)
  end

  def get_second_token_id(pair_address, %Network{} = network, opts \\ []) do
    get_pair_token_id(pair_address, network, "getSecondTokenId", opts)
  end

  defp get_pair_token_id(pair_address, %Network{} = network, method, opts \\ []) do
    sc_call = Sc.view_map_call(pair_address, method)

    with {:ok, data} <- REST.post_vm_values_query(sc_call, network),
         {:ok, sc_return} <-
           Sc.parse_view_sc_response(data) do
      {:ok, sc_return |> Enum.map(&Base.decode64!/1) |> hd()}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def get_reserve(pair_address, token_identifier, %Network{} = network, opts \\ []) do
    sc_call = Sc.view_map_call(pair_address, "getReserve", [token_identifier])
    REST.post_vm_values_int(sc_call, network)
  end

  def get_total_lp_token_supply(pair_address, %Network{} = network, opts \\ []) do
    sc_call = Sc.view_map_call(pair_address, "getTotalSupply")
    REST.post_vm_values_int(sc_call, network)
  end

  def get_lp_token_identifier(pair_address, %Network{} = network, opts \\ []) do
    Sc.view_map_call(pair_address, "getLpTokenIdentifier")
    |> REST.post_vm_values_string(network)
  end
end
