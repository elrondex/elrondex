defmodule Elrondex.Network do
  alias Elrondex.{Network, Endpoint, REST}

  @moduledoc """
  State of Elrond Network.
  """
  # TODO Node type (proxy vs node)	
  #
  defstruct name: nil,
            # TODO Do we need state?
            state: nil,
            # Endpoint for network
            endpoint: nil,
            # Config value loaded from `https://api.elrond.com/network/config`
            # e.g "1"
            erd_chain_id: nil,
            # e.g 18  
            erd_denomination: 18,
            # e.g 1500
            erd_gas_per_data_byte: 1500,
            # e.g "0.01"
            erd_gas_price_modifier: "0.01",
            # e.g "v1.1.64.0"
            erd_latest_tag_software_version: nil,
            # e.g 400
            erd_meta_consensus_group_size: nil,
            # e.g 50000
            erd_min_gas_limit: 50_000,
            # e.g 1_000_000_000
            erd_min_gas_price: 1_000_000_000,
            # e.g 1
            erd_min_transaction_version: 1,
            # e.g 400
            erd_num_metachain_nodes: nil,
            # e.g 400
            erd_num_nodes_in_shard: nil,
            # e.g 3 
            erd_num_shards_without_meta: 3,
            # e.g "2000000000000000000000000"
            erd_rewards_top_up_gradient_point: nil,
            # e.g 6000
            erd_round_duration: nil,
            # e.g 14400
            erd_rounds_per_epoch: nil,
            # e.g 63
            erd_shard_consensus_group_size: nil,
            # e.g 1_596_117_600
            erd_start_time: nil,
            # e.g "0.500000"
            erd_top_up_factor: nil

  @erd_string_fields [
    :erd_chain_id,
    :erd_gas_price_modifier,
    :erd_latest_tag_software_version,
    :erd_rewards_top_up_gradient_point,
    :erd_top_up_factor
  ]

  def new(network_name, endpoint_type \\ :proxy, endpoint_url \\ nil) do
    opts =
      case endpoint_url do
        nil -> [endpoint_type: endpoint_type]
        endpoint_url -> [endpoint_type: endpoint_type, endpoint_url: endpoint_url]
      end

    network =
      case network_name(network_name) do
        :mainnet -> mainnet(opts)
        :testnet -> testnet(opts)
        :devnet -> devnet(opts)
      end
  end

  # cached network 
  def get(network) when network in [:mainnet, :testnet, :devnet] do
    network =
      case network do
        :mainnet -> mainnet()
        :testnet -> testnet()
        :devnet -> devnet()
      end

    {:ok, config} = REST.get_network_config(network)

    config(network, config)
  end

  def load(%Network{} = network) do
    case REST.get_network_config(network) do
      {:ok, config} -> {:ok, config(network, config)}
      {:error, error} -> {:error, error}
    end
  end

  #
  # TODO https://gateway.elrond.com/ vs
  #      https://api.elrond.com/

  def mainnet(opts \\ []) do
    endpoint_type = Keyword.get(opts, :endpoint_type, :proxy)
    endpoint_url = Keyword.get(opts, :endpoint_url, "https://gateway.elrond.com")
    endpoint = Endpoint.new(endpoint_type, endpoint_url)
    %Network{name: :mainnet, endpoint: endpoint, erd_chain_id: "1"}
  end

  def testnet(opts \\ []) do
    endpoint_type = Keyword.get(opts, :endpoint_type, :proxy)
    endpoint_url = Keyword.get(opts, :endpoint_url, "https://testnet-gateway.elrond.com")
    endpoint = Endpoint.new(endpoint_type, endpoint_url)
    %Network{name: :testnet, endpoint: endpoint, erd_chain_id: "T"}
  end

  def devnet(opts \\ []) do
    endpoint_type = Keyword.get(opts, :endpoint_type, :proxy)
    endpoint_url = Keyword.get(opts, :endpoint_url, "https://devnet-gateway.elrond.com")
    endpoint = Endpoint.new(endpoint_type, endpoint_url)
    %Network{name: :devnet, endpoint: endpoint, erd_chain_id: "D"}
  end

  def config(network, config) do
    config(network, config, Map.keys(network))
  end

  defp config(network, _config, []) do
    network
  end

  defp config(network, config, [hkey | tkeys]) do
    # string(true) or integer(false) key
    type = Enum.member?(@erd_string_fields, hkey)
    # Filter only erd_* keys
    network_updated =
      case Atom.to_string(hkey) do
        "erd_" <> _rest = skey -> config_set(network, hkey, Map.get(config, skey), type)
        _ -> network
      end

    config(network_updated, config, tkeys)
  end

  defp config_set(network, key, value, true) when is_binary(value) do
    Map.put(network, key, value)
  end

  defp config_set(network, key, value, false) when is_integer(value) do
    Map.put(network, key, value)
  end

  defp config_set(network, _key, _value, _type) do
    network
  end

  defp network_name(network_name) when network_name in [:mainnet, :testnet, :devnet] do
    network_name
  end

  defp network_name("mainnet"), do: :mainnet
  defp network_name("testnet"), do: :testnet
  defp network_name("devnet"), do: :devnet
end
