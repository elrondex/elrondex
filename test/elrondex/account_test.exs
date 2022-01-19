defmodule Elrondex.AccountTest do
  alias Elrondex.{Account, Transaction, Network, REST}

  use ExUnit.Case
  doctest Elrondex.Account

  @mnemonic "worry swing expect okay gym ridge check sniff civil scissors planet brain snack rookie walnut dove tuna city train embark plunge odor metal next"

  def assert_account(%Account{} = account) do
    # Test address
    assert account.address == "erd1v0hgu2cug06qtwhtv29g3286t3mu4x6mej4gtt3sy8aa0xdkg5rsxckh4w"

    # Test public_key
    assert account |> Account.hex_public_key() ==
             "63ee8e2b1c43f405baeb628a88a8fa5c77ca9b5bccaa85ae3021fbd799b64507"

    # Test private_key
    assert account |> Account.hex_private_key() ==
             "4af3eacd64143a47cfa58d390452d7c960bf267f01f085f5ac513311d3e0c42b"
  end

  test "from_mnemonic" do
    account = Account.from_mnemonic(@mnemonic)
    # IO.inspect(account)    
    assert_account(account)
  end

  test "from_private_key" do
    account =
      Account.from_private_key("4af3eacd64143a47cfa58d390452d7c960bf267f01f085f5ac513311d3e0c42b")

    # IO.inspect(account)    
    assert_account(account)
  end

  test "from_public_key" do
    account =
      Account.from_public_key("63ee8e2b1c43f405baeb628a88a8fa5c77ca9b5bccaa85ae3021fbd799b64507")

    # IO.inspect(account)    
    # Test address
    assert account.address == "erd1v0hgu2cug06qtwhtv29g3286t3mu4x6mej4gtt3sy8aa0xdkg5rsxckh4w"

    # Test public_key
    assert account |> Account.hex_public_key() ==
             "63ee8e2b1c43f405baeb628a88a8fa5c77ca9b5bccaa85ae3021fbd799b64507"
  end

  test "from_address" do
    # TODo
  end

  test "generate_random" do
    account = Account.generate_random()
    # IO.inspect(account)
    assert byte_size(account.address) == 62
    assert byte_size(account.public_key) == 32
    assert byte_size(account.private_key) == 32
  end

  test "sign" do
    account = Account.generate_random()
    data_to_sign = "my data"
    signature = Account.sign(data_to_sign, account)
    assert byte_size(signature) == 64
    assert Account.sign_verify(data_to_sign, signature, account) == true
    # Check signature in hex format
    hex_signature_upper = Base.encode16(signature, case: :upper)
    assert Account.sign_verify(data_to_sign, hex_signature_upper, account) == true
    hex_signature_lower = Base.encode16(signature, case: :lower)
    assert Account.sign_verify(data_to_sign, hex_signature_lower, account) == true
  end

  # TODO This is integration test and plan to move on new place 
  test "sign and verify transaction" do
    testnet = Network.testnet()
    {:ok, config} = REST.get_network_config(testnet)
    # load testnet config 
    testnet =
      testnet
      |> Network.config(config)

    public_key = "63ee8e2b1c43f405baeb628a88a8fa5c77ca9b5bccaa85ae3021fbd799b64507"
    from_account = Account.generate_random()
    to_account = Account.from_public_key(public_key)
    value = "10000000000000000"
    data = nil
    sign_account = Account.from_address(from_account.address)

    sign_tr =
      from_account
      |> Transaction.transaction(to_account.address, value, data)
      |> Transaction.prepare(testnet)
      |> Transaction.sign()

    sign_to_verify = %{sign_tr | account: nil}

    assert Transaction.sign_verify(sign_to_verify, sign_account) == true
    assert Transaction.sign_verify(sign_to_verify) == true

    IO.inspect(sign_tr)
  end
end
