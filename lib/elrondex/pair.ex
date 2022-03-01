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
end
