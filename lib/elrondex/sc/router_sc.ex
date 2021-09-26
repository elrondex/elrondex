defmodule Elrondex.Sc.RouterSc do
  alias Elrondex.{Sc, Account, Transaction, Network, REST, ESDT, Pair}

  def get_all_pairs_addresses(router_address, %Network{} = network, opts \\ []) do
    sc_call = Sc.view_map_call(router_address, "getAllPairsAddresses")

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
end
