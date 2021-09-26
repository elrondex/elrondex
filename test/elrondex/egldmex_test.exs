defmodule Elrondex.EgldmexTest do
  alias Elrondex.{Network, REST}

  use ExUnit.Case

  @tag :skip
  test "SC egldmex tokens" do
    testnet = Network.testnet()
    address = "erd1qqqqqqqqqqqqqpgquh2r06qrjesfv5xj6v8plrqm93c6xvw70n4sfuzpmc"

    {:ok, esdt} = REST.get_address_esdt(testnet, address)
    # IO.inspect(esdt)
    {lp_mex, ""} = esdt |> Map.get("MEX-ec32fa") |> Map.get("balance") |> Integer.parse()
    {lp_wegld, ""} = esdt |> Map.get("WEGLD-073650") |> Map.get("balance") |> Integer.parse()

    IO.inspect(lp_mex)
    IO.inspect(lp_wegld)
  end

  @tag :skip
  test "Calculate new EGLD value" do
    testnet = Network.testnet()
    address = "erd1qqqqqqqqqqqqqpgquh2r06qrjesfv5xj6v8plrqm93c6xvw70n4sfuzpmc"

    {:ok, esdt} = REST.get_address_esdt(testnet, address)
    # IO.inspect(esdt)
    {lp_mex, ""} = esdt |> Map.get("MEX-ec32fa") |> Map.get("balance") |> Integer.parse()
    {lp_wegld, ""} = esdt |> Map.get("WEGLD-073650") |> Map.get("balance") |> Integer.parse()

    IO.inspect(lp_mex)
    IO.inspect(lp_wegld)

    mex_value = 4493.011745026496328009
    wegld_value = mex_value * lp_wegld / lp_mex

    IO.inspect(wegld_value)
  end
end
