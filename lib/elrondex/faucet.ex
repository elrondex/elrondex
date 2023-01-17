defmodule Elrondex.Faucet do
  alias Elrondex.Account

  use GenServer

  defstruct active: false,
            account: nil

  def start_link(opts \\ []) do
    faucet_opts =
      case Application.fetch_env(:elrondex, Elrondex.Faucet) do
        {:ok, config_opts} -> config_opts
        :error -> []
      end
      |> Keyword.merge(name: Elrondex.Faucet)
      |> Keyword.merge(opts)

    active = Keyword.get(faucet_opts, :active, false)
    faucet_mnemonic = Keyword.get(faucet_opts, :faucet_mnemonic, nil)

    GenServer.start_link(
      __MODULE__,
      {active, faucet_mnemonic},
      Keyword.take(faucet_opts, [:name])
    )
  end

  @impl true
  def init({active, faucet_mnemonic}) do
    state =
      case active do
        true -> %__MODULE__{active: true, account: Account.from_mnemonic(faucet_mnemonic)}
        false -> %__MODULE__{active: false, account: nil}
      end

    {:ok, state}
  end

  @spec get_active() :: boolean()
  def get_active() do
    get_active(Elrondex.Faucet)
  end

  @spec get_active(atom | pid) :: boolean()
  def get_active(pid) do
    GenServer.call(pid, :get_active)
  end

  def get_account() do
    get_account(Elrondex.Faucet)
  end

  def get_account!() do
    {:ok, account} = get_account()
    account
  end

  def get_account(pid) do
    GenServer.call(pid, :get_account)
  end

  @impl true
  def handle_call(:get_active, _from, state) do
    {:reply, state.active, state}
  end

  @impl true
  def handle_call(:get_account, _from, state) do
    reply =
      case state.active do
        true -> {:ok, state.account}
        false -> {:error, :inactive}
      end

    {:reply, reply, state}
  end
end
