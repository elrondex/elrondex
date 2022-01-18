defmodule Elrondex.Sc.RouterSc do
  alias Elrondex.{Sc, Account, Transaction, Network, REST, ESDT, Pair}
  alias Elrondex.Sc.{PairSc}

  @deprecated "Use get_all_pairs_managed_addresses/3 instead"
  def get_all_pairs_addresses(router_address, %Network{} = network, opts \\ []) do
    get_all_pairs_managed_addresses(router_address, network, opts)
  end

  def get_all_pairs_managed_addresses(router_address, %Network{} = network, opts \\ []) do
    # This is old name 
    # sc_call = Sc.view_map_call(router_address, "getAllPairsAddresses")

    sc_call = Sc.view_map_call(router_address, "getAllPairsManagedAddresses")

    with {:ok, data} <- REST.post_vm_values_query(sc_call, network),
         {:ok, sc_return} <-
           Sc.parse_view_sc_response(data) do
      {:ok,
       sc_return
       |> Enum.map(&Base.decode64!/1)
       |> Enum.map(&Account.public_key_to_address/1)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def get_all_pairs(router_address, %Network{} = network, opts \\ []) do
    case get_all_pairs_addresses(router_address, network, opts) do
      {:ok, pairs_addresses} -> get_pairs_form_addresses(pairs_addresses, [], network, opts)
      {:error, _} = error -> error
    end
  end

  defp get_pairs_form_addresses([], pairs_acc, network, opts) do
    {:ok, pairs_acc}
  end

  defp get_pairs_form_addresses([h | t], pairs_acc, network, opts) do
    case PairSc.get_pair(h, network, opts) do
      {:ok, pair} -> get_pairs_form_addresses(t, [pair | pairs_acc], network, opts)
      {:error, _} = error -> error
    end
  end
end
