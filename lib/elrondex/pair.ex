defmodule Elrondex.Pair do
  alias Elrondex.{Pair}

  defstruct address: nil,
            first_token: nil,
            second_token: nil

  def get_egldbusd_pair do
    %Pair{
      address: "erd1qqqqqqqqqqqqqpgq3gmttefd840klya8smn7zeae402w2esw0n4sm8m04f",
      first_token: "WEGLD-88600a",
      second_token: "BUSD-05b16f"
    }
  end

  def token_identifier(%Pair{first_token: identifier}, identifier) when is_binary(identifier) do
    identifier
  end

  def token_identifier(%Pair{second_token: identifier}, identifier) when is_binary(identifier) do
    identifier
  end
end
