defmodule Mainnet.WrapEgldScTest do
  alias Elrondex.{Account, Transaction, Network, REST}
  alias Elrondex.Sc.WrapEgldSc

  use ExUnit.Case

  @wegld_identifier "WEGLD-bd4d79"

  test "get_wrapped_egld_token_id test" do
    mainnet = Network.get(:mainnet)

    wrapped_egld_address = "erd1qqqqqqqqqqqqqpgqhe8t5jewej70zupmh44jurgn29psua5l2jps3ntjj3"

    {:ok, value} =
      wrapped_egld_address
      |> WrapEgldSc.get_wrapped_egld_token_id(mainnet)

    IO.inspect(value)

    assert value == @wegld_identifier
  end
end
