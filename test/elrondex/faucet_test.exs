defmodule Elrondex.FaucetTest do
  alias Elrondex.{Faucet}
  alias Elrondex.Test.Alice
  use ExUnit.Case
  doctest Elrondex.Faucet

  setup_all do
    {:ok, faucet} =
      case Faucet.start_link() do
        {:ok, faucet} -> {:ok, faucet}
        {:error, {:already_started, faucet}} -> {:ok, faucet}
      end

    {:ok, faucet: faucet}
  end

  test "inactive faucet" do
    {:ok, faucet} = Faucet.start_link(name: :test0, active: false)
    assert false == Faucet.get_active(faucet)

    assert {:error, :inactive} == Faucet.get_account(faucet)
  end

  test "test Alice as faucet" do
    {:ok, faucet} = Faucet.start_link(name: :test1, faucet_mnemonic: Alice.mnemonic())
    assert true == Faucet.get_active(faucet)

    {:ok, account} = Faucet.get_account(faucet)
    assert Alice.address() == account.address
  end

  test "config test faucet", state do
    assert true == Faucet.get_active()
    assert true == Faucet.get_active(state.faucet)

    {:ok, account1} = Faucet.get_account(state.faucet)
    {:ok, account2} = Faucet.get_account()
    assert account1 == account2
  end
end
