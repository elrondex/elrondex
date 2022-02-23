if Mix.env() != :prod do
  defmodule Elrondex.Test.Pair do
    alias Elrondex.{Network}
    alias Elrondex.Sc.{PairSc}

    def wegld_usdc_pair do
      %Elrondex.Pair{
        address: "erd1qqqqqqqqqqqqqpgqeel2kumf0r8ffyhth7pqdujjat9nx0862jpsg2pqaq",
        first_decimals: 18,
        first_token: "WEGLD-bd4d79",
        name: nil,
        second_decimals: 6,
        second_token: "USDC-c76f1f"
      }
    end
  end
end
