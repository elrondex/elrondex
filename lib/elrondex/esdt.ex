defmodule Elrondex.ESDT do
  alias Elrondex.{Sc, ESDT, Account, Transaction, Network, REST}

  @esdt_built_in_address "erd1qqqqqqqqqqqqqqqpqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzllls8a5w6u"

  # The creator of the ESDT
  defstruct account: nil,

            # The name of the token. It's length can be between 3 and 20 alphanumeric characters
            name: nil,
            # Type
            type: nil,
            # The abreviation of the token. The length can be between 3 and 10 alphanumeric UPPERCASE characters
            ticker: nil,
            # How many decimals the token has. It can have as low as 0 and as many as 18
            number_of_decimals: nil,
            # How many tokens should there first exist. This is an integer value, and
            # the value of 1 would mean 0.00...001 tokens, as many 0's as the number of decimals
            initial_supply: nil,
            # The identifier of the token, used in transactions.
            # This contains the ticker with some extra padding for making it unique.
            identifier: nil,

            ## PROPERTIES ##

            # Allows the token manager to freeze the balance of a specific acount, preventing transfers. Default: ???
            ### Testnet was reset, I can't create a new token to see what is the default.
            canFreeze: nil,
            # Allows the token manager the wipe (set to 0) the balance of a frozen account. Default: ???
            canWipe: nil,
            # Allows the token manager to prevent ALL transactions of the token, with the exception of minting and burning. Default: ???
            canPause: nil,
            # Allows the token manager to mint (create) more tokens. Default: ???
            canMint: nil,
            # Allows the token manager to burn (their) tokens. Default: ???
            canBurn: nil,
            # Allows the token manager role to another account. Default: ???
            canChangeOwner: nil,
            # Allows the token manager to change these properties (can_wipe, can_...). Default: ???
            canUpgrade: nil,
            # Allows the token manager to assign specific role(s). Default: ???
            # ESDTRoleLocalBurn: an address with this role can burn tokens
            # ESDTRoleLocalMint: an address with this role can mint new tokens
            canAddSpecialRoles: nil,
            isPaused: nil,
            canTransferNFTCreateRole: nil,
            nftCreateStopped: nil,
            numDecimals: nil,
            numWiped: nil

  def burn(%Account{} = account, %ESDT{} = esdt, value) when is_integer(value) do
    hex_identifier = hex_encode(esdt.identifier)
    hex_burn_value = hex_encode(value)
    data = "ESDTBurn@#{hex_identifier}@#{hex_burn_value}"
    tr = Transaction.transaction(account, @esdt_built_in_address, "0", data)
    # TODO what value we have here gasLimit
    %{tr | gasLimit: 60_000_000}
  end

  def multi_esdt_nft_transfer(%Account{} = account, reciver, first_token,first_value, second_token, second_value) do
    reciver_account = Account.from_address(reciver)
    data = Sc.data_call("MultiESDTNFTTransfer", [reciver_account.public_key, 2, first_token, 0, first_value, second_token, 0, second_value])
    tr = Transaction.transaction(account,account.address,0,data)
    %{tr | gasLimit: 2_200_000}
  end

  def multi_esdt_nft_transfer(%Account{} = account, reciver, tokens, more_args \\ []) when is_list(tokens) do
    # token = [{token, value}, {token, value} ...]
    # Enum.group_by(more_args, Sc.data_call
  end

  def transfer(%Account{} = account, receiver, %ESDT{} = esdt, value, more_args \\ [])
      when is_integer(value) do
    data = Sc.data_call("ESDTTransfer", [esdt.identifier, value | more_args])
    tr = Transaction.transaction(account, receiver, 0, data)
    # TODO what value we have here gasLimit
    %{tr | gasLimit: 500_000}
  end

  def mint(%Account{} = account, %ESDT{} = esdt, value) when is_integer(value) do
    hex_identifier = hex_encode(esdt.identifier)
    hex_mint_value = hex_encode(value)
    data = "mint@#{hex_identifier}@#{hex_mint_value}"
    tr = Transaction.transaction(account, @esdt_built_in_address, "0", data)
    %{tr | gasLimit: 60_000_000}
  end

  def pause(%Account{} = account, %ESDT{} = esdt) do
    hex_identifier = hex_encode(esdt.identifier)
    data = "pause@#{hex_identifier}"
    tr = Transaction.transaction(account, @esdt_built_in_address, "0", data)
    %{tr | gasLimit: 60_000_000}
  end

  def unpause(%Account{} = account, %ESDT{} = esdt) do
    hex_identifier = hex_encode(esdt.identifier)
    data = "unPause@#{hex_identifier}"
    tr = Transaction.transaction(account, @esdt_built_in_address, "0", data)
    %{tr | gasLimit: 60_000_000}
  end

  def freeze(%Account{} = account, %ESDT{} = esdt, target_address) do
    hex_identifier = hex_encode(esdt.identifier)
    hex_target_address = hex_encode(target_address)
    data = "freeze@#{hex_identifier}@#{hex_target_address}"
    tr = Transaction.transaction(account, @esdt_built_in_address, "0", data)
    %{tr | gasLimit: 60_000_000}
  end

  def unfreeze(%Account{} = account, %ESDT{} = esdt, target_address) do
    hex_identifier = hex_encode(esdt.identifier)
    hex_target_address = hex_encode(target_address)
    data = "unFreeze@#{hex_identifier}@#{hex_target_address}"
    tr = Transaction.transaction(account, @esdt_built_in_address, "0", data)
    %{tr | gasLimit: 60_000_000}
  end

  def wipe(%Account{} = account, %ESDT{} = esdt, target_address) do
    hex_identifier = hex_encode(esdt.identifier)
    hex_target_address = hex_encode(target_address)
    data = "wipe@#{hex_identifier}@#{hex_target_address}"
    tr = Transaction.transaction(account, @esdt_built_in_address, "0", data)
    %{tr | gasLimit: 60_000_000}
  end

  def set_roles(%Account{} = account, %ESDT{} = esdt, target_address, roles)
      when is_list(roles) and length(roles) > 0 do
    hex_identifier = hex_encode(esdt.identifier)
    target_address = target_address |> Account.from_address() |> Account.hex_public_key()
    hex_target_address = hex_encode(target_address)
    hex_roles = get_roles_data_hex(roles)
    data = "setSpecialRole@#{hex_identifier}@#{hex_target_address}@" <> hex_roles
    tr = Transaction.transaction(account, @esdt_built_in_address, "0", data)
    %{tr | gasLimit: 60_000_000}
  end

  def unset_roles(%Account{} = account, %ESDT{} = esdt, target_address, roles)
      when is_list(roles) and length(roles) > 0 do
    hex_identifier = hex_encode(esdt.identifier)
    hex_target_address = hex_encode(target_address)
    hex_roles = get_roles_data_hex(roles)
    data = "unSetSpecialRole@#{hex_identifier}@#{hex_target_address}@" <> hex_roles
    tr = Transaction.transaction(account, @esdt_built_in_address, "0", data)
    %{tr | gasLimit: 60_000_000}
  end

  def trasnfer_ownership(%Account{} = account, %ESDT{} = esdt, target_address) do
    hex_identifier = hex_encode(esdt.identifier)
    hex_target_address = hex_encode(target_address)
    data = "transferOwnership@#{hex_identifier}@#{hex_target_address}"
    tr = Transaction.transaction(account, @esdt_built_in_address, "0", data)
    %{tr | gasLimit: 60_000_000}
  end

  # TODO: How do we operate here? Do we let the user give us a map of (changed) values, or do we only ask for a list of changed values that we will update from `esdt`
  # Or perhaps in another way?
  def upgrade(%Account{} = account, %ESDT{} = esdt) do
    hex_identifier = hex_encode(esdt.identifier)
    # hex_properties = get_esdt_properties_hex(esdt)
    # data = "controlChanges@#{hex_identifier}" <> hex_properties
    # tr = Transaction.transaction(account, @esdt_built_in_address, "0", data)
    # %{tr | gasLimit: 60_000_000}
    nil
  end

  # TODO Do we need this or is fine to make direct call to REST.post_vm_values_query/2
  def get_esdt_properties_map(%ESDT{} = esdt) do
    %{
      "scAddress" => @esdt_built_in_address,
      funcName: "getTokenProperties",
      args: [hex_encode(esdt.identifier)]
    }
  end

  defdelegate hex_encode(value), to: Sc

  defp get_roles_data_hex(roles) when is_list(roles) do
    roles |> Enum.map(&get_role_name/1) |> Enum.join("@")
  end

  defp get_role_name(:local_burn), do: hex_encode("ESDTRoleLocalBurn")
  defp get_role_name(:local_mint), do: hex_encode("ESDTRoleLocalMint")

  def set_esdt_properties([name, type, address, supply, burnt | properties], %ESDT{} = esdt) do
    esdt = %{
      esdt
      | name: name,
        type: type,
        account: Account.from_public_key(address),
        initial_supply: supply
    }

    Enum.reduce(properties, esdt, &set_esdt_property/2)
  end

  # TODO "CanTransferNFTCreateRole-false"
  def set_esdt_property("CanUpgrade-true", %ESDT{} = esdt),
    do: %{esdt | canUpgrade: true}

  def set_esdt_property("CanUpgrade-false", %ESDT{} = esdt),
    do: %{esdt | canUpgrade: false}

  def set_esdt_property("CanMint-true", %ESDT{} = esdt),
    do: %{esdt | canMint: true}

  def set_esdt_property("CanMint-false", %ESDT{} = esdt),
    do: %{esdt | canMint: false}

  def set_esdt_property("CanBurn-true", %ESDT{} = esdt),
    do: %{esdt | canBurn: true}

  def set_esdt_property("CanBurn-false", %ESDT{} = esdt),
    do: %{esdt | canBurn: false}

  def set_esdt_property("CanChangeOwner-true", %ESDT{} = esdt),
    do: %{esdt | canChangeOwner: true}

  def set_esdt_property("CanChangeOwner-false", %ESDT{} = esdt),
    do: %{esdt | canChangeOwner: false}

  def set_esdt_property("CanPause-true", %ESDT{} = esdt),
    do: %{esdt | canPause: true}

  def set_esdt_property("CanPause-false", %ESDT{} = esdt),
    do: %{esdt | canPause: false}

  def set_esdt_property("IsPaused-true", %ESDT{} = esdt),
    do: %{esdt | isPaused: true}

  def set_esdt_property("IsPaused-false", %ESDT{} = esdt),
    do: %{esdt | isPaused: false}

  def set_esdt_property("CanFreeze-true", %ESDT{} = esdt),
    do: %{esdt | canFreeze: true}

  def set_esdt_property("CanFreeze-false", %ESDT{} = esdt),
    do: %{esdt | canFreeze: false}

  def set_esdt_property("CanWipe-true", %ESDT{} = esdt),
    do: %{esdt | canWipe: true}

  def set_esdt_property("CanWipe-false", %ESDT{} = esdt),
    do: %{esdt | canWipe: false}

  def set_esdt_property("CanAddSpecialRoles-true", %ESDT{} = esdt),
    do: %{esdt | canAddSpecialRoles: true}

  def set_esdt_property("CanAddSpecialRoles-false", %ESDT{} = esdt),
    do: %{esdt | canAddSpecialRoles: false}

  def set_esdt_property("CanTransferNFTCreateRole-true", %ESDT{} = esdt),
    do: %{esdt | canTransferNFTCreateRole: true}

  def set_esdt_property("CanTransferNFTCreateRole-false", %ESDT{} = esdt),
    do: %{esdt | canTransferNFTCreateRole: false}

  def set_esdt_property("NFTCreateStopped-true", %ESDT{} = esdt),
    do: %{esdt | nftCreateStopped: true}

  def set_esdt_property("NFTCreateStopped-false", %ESDT{} = esdt),
    do: %{esdt | nftCreateStopped: false}

  def set_esdt_property("NumDecimals-" <> nd, %ESDT{} = esdt) do
    {numDecimals, ""} = Integer.parse(nd)
    %{esdt | numDecimals: numDecimals}
  end

  def set_esdt_property("NumWiped-" <> nw, %ESDT{} = esdt) do
    {numWiped, ""} = Integer.parse(nw)
    %{esdt | numWiped: numWiped}
  end

  def set_esdt_property(property, %ESDT{} = esdt) do
    # TODO change that to Logger
    IO.puts("Unexpected property for esdt: #{inspect(property)}")
    esdt
  end

  def get_rest_esdt(%ESDT{} = esdt, %Network{} = network) do
    query_map = %{
      "scAddress" => @esdt_built_in_address,
      funcName: "getTokenProperties",
      args: [hex_encode(esdt.identifier)]
    }

    with {:ok, data} <- REST.post_vm_values_query(query_map, network),
         {:ok, data} <- get_rest_esdt_parse(data) do
      {:ok, set_esdt_properties(data, esdt)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_rest_esdt_parse(%{"returnCode" => "ok", "returnData" => data})
       when is_list(data) do
    {:ok, Enum.map(data, &Base.decode64!/1)}
  end

  defp get_rest_esdt_parse(data) do
    {:error, {:invalid_data, data}}
  end
end
