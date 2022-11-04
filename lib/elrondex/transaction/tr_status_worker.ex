defmodule Elrondex.Transaction.TrStatusWorker do
  alias Elrondex.{Network, REST}

  use GenServer

  defstruct tx_hash: nil,
            network: nil,
            pids: nil,
            status: nil,
            refresh_delay: 0,
            error_delay: 10

  def start_link(tx_hash, %Network{} = network, pids) when is_list(pids) do
    state = %__MODULE__{
      tx_hash: tx_hash,
      network: network,
      pids: pids,
      status: :none
    }

    GenServer.start_link(__MODULE__, state)
  end

  @impl true
  def init(state) do
    refresh_state(0)
    {:ok, state}
  end

  @impl true
  def handle_info(:refresh, state) do
    # Get transaction status
    case REST.get_transaction_status(state.network, state.tx_hash) do
      {:ok, status} ->
        status = get_status_map(status)

        # If status is changed we notify each pid 
        case status == state.status do
          false -> send_new_status(state.pids, status, state)
          true -> :skip
        end

        case is_pending_status(status) do
          true ->
            refresh_state(state.refresh_delay)
            {:noreply, %{state | status: status}}

          false ->
            {:stop, :normal, %{state | status: status}}
        end

      {:error, error} ->
        # On error we continue to looking for state
        refresh_state(state.error_delay)
        {:noreply, state}
    end
  end

  defp refresh_state(0) do
    send(self(), :refresh)
  end

  defp refresh_state(delay) when is_integer(delay) do
    Process.send_after(self(), :refresh, delay)
  end

  defp send_new_status([], status, state) do
  end

  defp send_new_status([pid | pids], status, state) do
    send(pid, {:status, state.tx_hash, status})
    send_new_status(pids, status, state)
  end

  def is_pending_status(:pending) do
    true
  end

  def is_pending_status(_status) do
    false
  end

  defp get_status_map("pending") do
    :pending
  end

  defp get_status_map("success") do
    :success
  end

  defp get_status_map("invalid") do
    :invalid
  end

  defp get_status_map(status) do
    status
  end
end
