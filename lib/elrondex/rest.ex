defmodule Elrondex.REST do
  alias Elrondex.{Network, Transaction}

  @moduledoc """
  The Elrond REST API to interact with the Elrond Blockchain.
  """

  def test_config(%Network{} = network) do
    Tesla.get(network.endpoint.client, "/network/config")
    |> client_response()
  end

  def get_network_config(%Network{} = network) do
    Tesla.get(network.endpoint.client, "/network/config")
    |> client_response(["config"])
  end

  # TODO network first arg? or second?
  def get_address(%Network{} = network, bech32) do
    Tesla.get(network.endpoint.client, "/address/#{bech32}")
    |> client_response(["account"])
  end

  def get_address_nonce(%Network{} = network, bech32) do
    Tesla.get(network.endpoint.client, "/address/#{bech32}/nonce")
    |> client_response(["nonce"])
  end

  def get_address_balance(%Network{} = network, bech32) do
    Tesla.get(network.endpoint.client, "/address/#{bech32}/balance")
    |> client_response(["balance"])
  end

  def get_address_esdt(%Network{} = network, bech32) do
    Tesla.get(network.endpoint.client, "/address/#{bech32}/esdt")
    |> client_response(["esdts"])
  end

  # TODO "error" => "Not Found"
  # Is working on https://gateway.elrond.com
  # Not working on https://api.elrond.com/
  def get_address_esdt_balance(%Network{} = network, bech32, token) do
    Tesla.get(network.endpoint.client, "/address/#{bech32}/esdt/#{token}")
    |> client_response(["tokenData"])
  end

  def get_address_transactions(%Network{} = network, bech32) do
    Tesla.get(network.endpoint.client, "/address/#{bech32}/transactions")
    |> client_response(["transactions"])
  end

  # TODO "error" => "Not Found"
  def get_address_keys(%Network{} = network, bech32) do
    Tesla.get(network.endpoint.client, "/address/#{bech32}/keys")
    |> client_response(["pairs"])
  end

  def post_transaction_send(%Transaction{} = tr) do
    post_transaction_send(Transaction.to_signed_map(tr), tr.network)
  end

  def post_transaction_send(signed_map, %Network{} = network) when is_map(signed_map) do
    IO.inspect(signed_map)

    Tesla.post(network.endpoint.client, "/transaction/send", signed_map)
    |> client_response(["txHash"])
  end

  def get_transaction(%Network{} = network, tx_hash, query_opts \\ []) do
    query = Keyword.take(query_opts, [:sender, :withResults])

    Tesla.get(network.endpoint.client, "/transaction/#{tx_hash}", query: query)
    |> client_response(["transaction"])
  end

  # "error" => "Not Found", "message" => "Cannot GET /network/esdts", "statusCode" => 404
  # TODO? This involves a vm query request to the ESDT address. 
  # Is working on https://gateway.elrond.com
  # Not working on https://api.elrond.com/
  def get_network_esdts(%Network{} = network) do
    Tesla.get(network.endpoint.client, "/network/esdts")
    |> client_response(["tokens"])
  end

  def post_vm_values_query(query_map, %Network{} = network) do
    IO.inspect(query_map)

    Tesla.post(network.endpoint.client, "/vm-values/query", query_map)
    |> client_response(["data"])
  end

  def post_vm_values_string(query_map, %Network{} = network) do
    IO.inspect(query_map)

    Tesla.post(network.endpoint.client, "/vm-values/string", query_map)
    |> client_response(["data"])
  end

  def post_vm_values_int(query_map, %Network{} = network) do
    IO.inspect(query_map)

    Tesla.post(network.endpoint.client, "/vm-values/int", query_map)
    |> client_response(["data"])
    |> int_response()
  end

  #######################################

  def client_response({:ok, response}, path \\ []) do
    body_response(response.body, path)
  end

  def client_response({:error, response}, _path) do
    {:error, response}
  end

  # TODO do we need this?
  def client_response(invalid, _path) do
    {:error, invalid}
  end

  def body_response(%{"code" => "successful", "data" => data}, path \\ []) when is_list(path) do
    {:ok, data_from_path(data, path)}
  end

  def body_response(%{"error" => error, "code" => code}, _path) do
    {:error, "code: #{code} error: #{error}"}
  end

  def body_response(body, _path) do
    IO.puts("Unexpected body: #{inspect(body)}")
    {:error, body}
  end

  def data_from_path(map, []) do
    map
  end

  def data_from_path(map, [h | t]) when is_map(map) do
    data_from_path(Map.get(map, h), t)
  end

  def data_from_path(data, path) do
    IO.puts("Unexpected path for data: #{inspect(data)} path: #{inspect(path)} ")
    data
  end

  def int_response({:ok, response}) when is_binary(response) do
    case Integer.parse(response) do
      {value, ""} when is_integer(value) -> {:ok, value}
      _ -> {:error, "invalid integer value #{response}"}
    end
  end

  def int_response({:ok, response}) when is_integer(response) do
    {:ok, response}
  end

  def int_response({:error, response}) do
    {:error, response}
  end
end
