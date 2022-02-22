defmodule Elrondex.PassphraseTest do
  alias Elrondex.{Account}

  use ExUnit.Case

  @mnemonic "today stove love coyote left dentist any route common zone gate often gas tray fish trigger march elder bamboo one half baby space knock"
  @passphrase "abcdefghi"

  test "from mnemonic no passphrase account index 0" do
    account = Account.from_mnemonic(@mnemonic)
    assert account.address == "erd16suhsrmnwk9hvzzj3qu8tn0k4e5dgmw8kwkq728jn34zceyh9u8q9uzp8f"
  end

  test "from mnemonic no passphrase account index 5" do
    account = Account.from_mnemonic(@mnemonic, "", 5)
    assert account.address == "erd1fc3mhtkm3c2qu34cztk3zywhpjgjw5zflt9a7crqekyu7rgzyuuqqg6yqd"
  end

  test "from mnemonic no passphrase account index 9" do
    account = Account.from_mnemonic(@mnemonic, "", 9)
    assert account.address == "erd1qhkn9j2ckaj2es5vgn3jzlrqh8cvxpxr6ft690rpw63du52lr3wqlgz65f"
  end

  test "from mnemonic with passphrase account index 0" do
    account = Account.from_mnemonic(@mnemonic, @passphrase)
    assert account.address == "erd18nu9c2fx32gu274j9ep0kk0npcapsdr93tyrqc4qezezg5aa3g3sn0cml3"
  end

  test "from mnemonic with passphrase account index 5" do
    account = Account.from_mnemonic(@mnemonic, @passphrase, 5)
    assert account.address == "erd1439pj3y7cduqnsh0yt4ejersfftw2mmss89nfnem86t40c00rg5qyj27zx"
  end

  test "from mnemonic with passphrase account index 9" do
    account = Account.from_mnemonic(@mnemonic, @passphrase, 9)
    assert account.address == "erd1d0gupnd9hcc8e8ur7k2zjg2kldka6e046strvn278k0yuqjldmvsfnxe2d"
  end
end
