defmodule Elrondex.Sc.PairSc do
  alias Elrondex.{Sc, Transaction, Account, REST, ESDT, Pair, Network, Test}
  alias Elrdonex.Sc.{PairSc}

  @doc """
  Swaps a certain token amount with fixed amount value on input and minimum amount value on output.

  ## Arguments
    * `account` - An account's struct
    * `pair` -  A pair struct 
    * `token_in` - Token identifier that we provide on input for swap operation
    * `value_in` - Fixed amount value for input token
    * `token_out` - Token identifier that we provide on output. The swap operation will return given token into account
    * `value_out_min` - Minimum amount for output token that is required for a successful swap operation

  ## Examples
      iex> Elrondex.Sc.PairSc.swap_tokens_fixed_input(Elrondex.Test.Bob.account, 
      ...> Elrondex.Test.Pair.wegld_usdc_pair, 
      ...> "WEGLD-bd4d79", 
      ...> 1000_000_000_000_000_000, 
      ...> "USDC-c76f1f", 
      ...> 2 * 50 * 1_000_000)
      ...> |> Map.get(:data)
      "ESDTTransfer@5745474c442d626434643739@0de0b6b3a7640000@73776170546f6b656e734669786564496e707574@555344432d633736663166@05f5e100"
  """
  def swap_tokens_fixed_input(
        %Account{} = account,
        %Pair{} = pair,
        token_in,
        value_in,
        token_out,
        value_out_min
      ) do
    # data = "ESDTTransfer@#{token_in}@#{amount_in}@#{swap}@#{token_out}@#{amount_out}"
    esdt = %ESDT{identifier: Pair.token_identifier(pair, token_in)}

    ESDT.transfer(account, pair.address, esdt, value_in, [
      "swapTokensFixedInput",
      Pair.token_identifier(pair, token_out),
      value_out_min
    ])
    |> Map.put(:gasLimit, 50_000_000)
  end

  @doc """
  Swaps a certain token amount value on input for a fixed amount value on output.

  ## Arguments
    * `account` - An account's struct
    * `pair` -  A pair struct 
    * `token_in` - Token identifier that we provide on input for swap operation
    * `value_in_max` - Maximum amount value for input token
    * `token_out` - Token identifier that we provide on output. The swap operation will return given token into account
    * `value_out` - Fixed amount value for output token

  ## Examples
      iex> Elrondex.Sc.PairSc.swap_tokens_fixed_output(Elrondex.Test.Bob.account, 
      ...> Elrondex.Test.Pair.wegld_usdc_pair, 
      ...> "WEGLD-bd4d79", 
      ...> 130_000_000_000_000_0000, 
      ...> "USDC-c76f1f", 
      ...> 3 * 50 * 1_000_000)
      ...> |> Map.get(:data)
      "ESDTTransfer@5745474c442d626434643739@120a871cc0020000@73776170546f6b656e7346697865644f7574707574@555344432d633736663166@08f0d180"
      
  """
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

  # Pair a b
  # add_liquidity acc, pair, a, 2, b, 5
  # add_liquidity acc, pair, b, 5, a, 2
  #

  def add_liquidity(
        %Account{} = account,
        %Pair{first_token: first_token, second_token: second_token} = pair,
        first_value_transfer,
        first_value_min,
        second_value_transfer,
        second_value_min
      ) do
    ESDT.multi_esdt_nft_transfer(
      account,
      pair.address,
      [{pair.first_token, first_value_transfer}, {pair.second_token, second_value_transfer}],
      ["addLiquidity", first_value_min, second_value_min]
    )
    |> Map.put(:gasLimit, 12_000_000)
  end

  def add_liquidity(
        %Account{} = account,
        %Pair{first_token: first_token, second_token: second_token} = pair,
        {first_token, first_value_transfer, first_value_min},
        {second_token, second_value_transfer, second_value_min}
      ) do
    add_liquidity(
      account,
      pair,
      first_value_transfer,
      first_value_min,
      second_value_transfer,
      second_value_min
    )
  end

  def add_liquidity(
        %Account{} = account,
        %Pair{first_token: first_token, second_token: second_token} = pair,
        {second_token, second_value_transfer, second_value_min},
        {first_token, first_value_transfer, first_value_min}
      ) do
    add_liquidity(
      account,
      %Pair{} = pair,
      first_token,
      first_value_min,
      second_token,
      second_value_min
    )
  end

  def remove_liquidity(
        %Account{} = account,
        %Pair{} = pair,
        liquidity,
        first_token_amount_min,
        second_token_amount_min
      ) do
    esdt = %ESDT{identifier: pair.lp_token}

    ESDT.transfer(account, pair.address, esdt, liquidity, [
      "removeLiquidity",
      first_token_amount_min,
      second_token_amount_min
    ])
    |> Map.put(:gasLimit, 12_000_000)
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

  def get_pair(pair_address, %Network{} = network, opts \\ []) do
    with {:ok, first_token} <- get_first_token_id(pair_address, network, opts),
         {:ok, first_esdt} <- ESDT.get_rest_esdt(%ESDT{identifier: first_token}, network),
         {:ok, second_token} <- get_second_token_id(pair_address, network, opts),
         {:ok, second_esdt} <- ESDT.get_rest_esdt(%ESDT{identifier: second_token}, network),
         {:ok, lp_token} <- get_lp_token_identifier(pair_address, network, opts),
         {:ok, lp_esdt} <- ESDT.get_rest_esdt(%ESDT{identifier: lp_token}, network) do
      {:ok,
       %Pair{
         address: pair_address,
         first_token: first_token,
         first_decimals: first_esdt.numDecimals,
         second_token: second_token,
         second_decimals: second_esdt.numDecimals,
         lp_token: lp_token,
         lp_decimals: lp_esdt.numDecimals
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

  @doc """
  Returns true if fee is enabled for given pair or false if its disabled.

  ## Arguments
    * `pair_address` - A pair address 
    * `network` - A network
  """
  def get_fee_state(pair_address, %Network{} = network) do
    with {:ok, state} <-
           Sc.view_map_call(pair_address, "getFeeState")
           |> REST.post_vm_values_int(network) do
      case state do
        0 -> {:ok, false}
        1 -> {:ok, true}
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_enum_state(<<0>>), do: :inactive
  defp get_enum_state(<<1>>), do: :active
  defp get_enum_state(<<2>>), do: :active_noswaps
  defp get_enum_state(""), do: :unknown
end
