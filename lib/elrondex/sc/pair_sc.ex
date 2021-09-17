defmodule Elrondex.Sc.PairSc do
  alias Elrondex.{Sc, Transaction, Account, REST, ESDT, Pair}

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
end
