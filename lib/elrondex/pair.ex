defmodule Elrondex.Pair do
  alias Elrondex.{Pair}

  defstruct name: nil,
            address: nil,
            first_token: nil,
            first_decimals: nil,
            second_token: nil,
            second_decimals: nil,
            lp_token: nil,
            lp_decimals: nil

  def token_identifier(%Pair{first_token: identifier}, identifier) when is_binary(identifier) do
    identifier
  end

  def token_identifier(%Pair{second_token: identifier}, identifier) when is_binary(identifier) do
    identifier
  end

  def to_decimal(%Pair{first_token: identifier} = pair, identifier, value)
      when is_binary(identifier) and is_integer(value) do
    Decimal.new(1, value, -pair.first_decimals)
  end

  def to_decimal(%Pair{second_token: identifier} = pair, identifier, value)
      when is_binary(identifier) and is_integer(value) do
    Decimal.new(1, value, -pair.second_decimals)
  end

  def get_data_side(
        %Pair{first_token: first_token, second_token: second_token},
        [
          "ESDTTransfer",
          first_token,
          _first_value,
          "swapTokensFixedInput",
          second_token,
          _second_value
        ]
      ) do
    {:ok, :sell}
  end

  def get_data_side(
        %Pair{first_token: first_token, second_token: second_token},
        [
          "ESDTTransfer",
          second_token,
          _second_value,
          "swapTokensFixedInput",
          first_token,
          _first_value
        ]
      ) do
    {:ok, :buy}
  end

  def get_data_side(
        %Pair{first_token: first_token, second_token: second_token},
        [
          "ESDTTransfer",
          first_token,
          _first_value,
          "swapTokensFixedOutput",
          second_token,
          _second_value
        ]
      ) do
    {:ok, :sell}
  end

  def get_data_side(
        %Pair{first_token: first_token, second_token: second_token},
        [
          "ESDTTransfer",
          second_token,
          _second_value,
          "swapTokensFixedOutput",
          first_token,
          _first_value
        ]
      ) do
    {:ok, :buy}
  end

  def get_data_side(%Pair{}, _data) do
    {:error, :unknown}
  end
end
