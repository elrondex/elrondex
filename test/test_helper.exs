ExUnit.start()

defmodule TestData do
  use ExUnit.Case

  @test_data_path Path.join(__DIR__, "data")

  def test_data_path() do
    @test_data_path
  end

  def network_path(network) when network in [:mainnet, :testnet, :devnet] do
    Path.join(test_data_path(), "#{network}")
  end

  def tx_path(network, tx_hash) do
    network
    |> network_path()
    |> Path.join("tx")
    |> Path.join("#{tx_hash}.json")
  end

  def put_tx_data(network, tx_hash, tx_data) when is_binary(tx_data) do
    tx_file = tx_path(network, tx_hash)

    case File.exists?(tx_file) do
      false -> File.mkdir_p!(Path.dirname(tx_file))
      true -> raise "File #{tx_file} exists!"
    end

    File.write!(tx_file, tx_data)
  end

  def put_tx_data(network, tx_hash, tx_data) when is_map(tx_data) do
    tx_json = Jason.encode!(tx_data, pretty: true)
    put_tx_data(network, tx_hash, tx_json)
  end

  def assert_tx_data(network, tx_hash, tx_data) when is_map(tx_data) do
    tx_file = tx_path(network, tx_hash)

    case File.exists?(tx_file) do
      false -> put_tx_data(network, tx_hash, tx_data)
      true -> assert tx_data == Jason.decode!(File.read!(tx_file))
    end
  end
end

# IO.puts("TestData.test_data_path()=" <> TestData.test_data_path())
