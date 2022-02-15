defmodule Elrondex.Sc.PairSc do
  alias Elrondex.{Sc, Transaction, Account, REST, ESDT, Pair, Network}

  def swap_tokens_fixed_input(
        %Account{} = account,
        %Pair{} = pair,
        token_in,
        value_in,
        token_out,
        value_out
      ) do
    # data = "ESDTTransfer@#{token_in}@#{amount_in}@#{swap}@#{token_out}@#{amount_out}"
    esdt = %ESDT{identifier: Pair.token_identifier(pair, token_in)}

    ESDT.transfer(account, pair.address, esdt, value_in, [
      "swapTokensFixedInput",
      Pair.token_identifier(pair, token_out),
      value_out
    ])
    |> Map.put(:gasLimit, 50_000_000)
  end

  def swap_tokens_fixed_output(
        %Account{} = account,
        %Pair{} = pair,
        token_in,
        value_in_max,
        token_out,
        value_out
      ) do
    esdt = %ESDT{identifier: Pair.token_identifier(pair, token_in)}

    ESDT.transfer(account, pair.address, esdt, value_in_max, [
      "swapTokensFixedOutput",
      Pair.token_identifier(pair, token_out),
      value_out
    ])
    |> Map.put(:gasLimit, 50_000_000)
  end

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

  def get_amount_in(%Pair{} = pair, token_wanted_identifier, amount_wanted, %Network{} = network) do
    token_identifier = Pair.token_identifier(pair, token_wanted_identifier)

    Sc.view_map_call(pair.address, "getAmountIn", [token_identifier, amount_wanted])
    |> REST.post_vm_values_int(network)
  end

  def get_amount_out(%Pair{} = pair, token_in_identifier, amount_in, %Network{} = network) do
    token_identifier = Pair.token_identifier(pair, token_in_identifier)

    Sc.view_map_call(pair.address, "getAmountOut", [token_identifier, amount_in])
    |> REST.post_vm_values_int(network)
  end

  def get_burned_token_amount(token_identifier, %Network{} = network, opts \\ []) do
    Sc.view_map_call(token_identifier, "getBurnedTokenAmount")
    |> REST.post_vm_values_int(network)
  end

  def get_pair(pair_address, %Network{} = network, opts \\ []) do
    with {:ok, first_token} <- get_first_token_id(pair_address, network, opts),
         {:ok, first_esdt} <- ESDT.get_rest_esdt(%ESDT{identifier: first_token}, network),
         {:ok, second_token} <- get_second_token_id(pair_address, network, opts),
         {:ok, second_esdt} <- ESDT.get_rest_esdt(%ESDT{identifier: second_token}, network) do
      {:ok,
       %Pair{
         address: pair_address,
         first_token: first_token,
         first_decimals: first_esdt.numDecimals,
         second_token: second_token,
         second_decimals: second_esdt.numDecimals
       }}
    else
      {:error, reason} -> {:error, reason}
    end
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

  def get_total_fee_percent(pair_address, %Network{} = network, opts \\ []) do
    Sc.view_map_call(pair_address, "getTotalFeePercent")
    |> REST.post_vm_values_int(network)
  end

  def get_special_fee(pair_address, %Network{} = network, opts \\ []) do
    Sc.view_map_call(pair_address, "getSpecialFee")
    |> REST.post_vm_values_int(network)
  end

  def get_router_managed_address(pair_address, %Network{} = network, opts \\ []) do
    get_router_one_address("getRouterManagedAddress", pair_address, network)
  end

  def get_router_owner_managed_address(pair_address, %Network{} = network, opts \\ []) do
    get_router_one_address("getRouterOwnerManagedAddress", pair_address, network)
  end

  def get_extern_swap_gas_limit(pair_address, %Network{} = network, opts \\ []) do
    Sc.view_map_call(pair_address, "getExternSwapGasLimit")
    |> REST.post_vm_values_int(network)
  end

  defp get_router_one_address(sc_call, pair_address, %Network{} = network, opts \\ []) do
    with {:ok, data} <-
           Sc.view_map_call(pair_address, sc_call)
           |> REST.post_vm_values_query(network),
         {:ok, [sc_return]} <-
           Sc.parse_view_sc_response(data) do
      {:ok, sc_return |> Base.decode64!() |> Account.public_key_to_address()}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def get_state(pair_address, %Network{} = network, opts \\ []) do
    with {:ok, state} <-
           Sc.view_map_call(pair_address, "getState")
           |> REST.post_vm_values_string(network) do
      {:ok, get_enum_state(state)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_enum_state(<<0>>), do: :inactive
  defp get_enum_state(<<1>>), do: :active
  defp get_enum_state(<<2>>), do: :active_noswaps
  defp get_enum_state(""), do: :unknown
end
