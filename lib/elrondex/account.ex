defmodule Elrondex.Account do
  alias Elrondex.{Account}

  defstruct address: nil,
            username: nil,
            master_node: nil,
            public_key: nil,
            private_key: nil

  def public_key_to_address(public_key)
      when is_binary(public_key) and byte_size(public_key) == 32 do
    # Compute bech32 address
    Bech32.encode("erd", public_key)
  end

  def public_key_to_address(hex_public_key)
      when is_binary(hex_public_key) and byte_size(hex_public_key) == 64 do
    Base.decode16!(hex_public_key, case: :mixed)
    |> public_key_to_address()
  end

  def generate_random() do
    # Compute private_key
    {_, private_key} = :crypto.generate_key(:eddsa, :ed25519)

    from_private_key(private_key)
  end

  def from_private_key(private_key)
      when is_binary(private_key) and byte_size(private_key) == 32 do
    # Compute public key
    {public_key, ^private_key} = :crypto.generate_key(:eddsa, :ed25519, private_key)

    # Compute bech32 address
    address = Bech32.encode("erd", public_key)

    %Account{
      address: address,
      private_key: private_key,
      public_key: public_key
    }
  end

  def from_private_key(hex_private_key)
      when is_binary(hex_private_key) and byte_size(hex_private_key) == 64 do
    {:ok, private_key} = Base.decode16(hex_private_key, case: :mixed)
    from_private_key(private_key)
  end

  def from_public_key(public_key)
      when is_binary(public_key) and byte_size(public_key) == 32 do
    # Compute bech32 address
    address = Bech32.encode("erd", public_key)

    %Account{
      address: address,
      public_key: public_key
    }
  end

  def from_public_key(hex_public_key)
      when is_binary(hex_public_key) and byte_size(hex_public_key) == 64 do
    {:ok, public_key} = Base.decode16(hex_public_key, case: :mixed)
    from_public_key(public_key)
  end

  def from_address(address) do
    {:ok, "erd", public_key} = Bech32.decode(address)
    from_public_key(public_key)
  end

  # TODO Add account number
  def from_mnemonic(mnemonic, passphrase \\ "") do
    {:ok, mnemonic_seed} =
      Mnemo.seed(mnemonic, passphrase)
      |> Base.decode16(case: :lower)

    # Generate master node
    <<private_key::binary-32, chain_code::binary-32>> =
      if get_otp_version() >= 24 do
        :crypto.mac(:hmac, :sha512, "ed25519 seed", mnemonic_seed)
      else
        :crypto.hmac(:sha512, "ed25519 seed", mnemonic_seed)
      end

    master_node = {private_key, chain_code}
    # Compute final node
    # TODO [44, 508, account, 0, account_index]
    {private_key, _} = ckd_priv(master_node, [44, 508, 0, 0, 0])

    # Compute public key
    {public_key, ^private_key} = :crypto.generate_key(:eddsa, :ed25519, private_key)

    # Compute bech32 address
    address = Bech32.encode("erd", public_key)

    %Account{
      address: address,
      master_node: master_node,
      private_key: private_key,
      public_key: public_key
    }
  end

  # Child Key Derivation Function
  defp ckd_priv({_key, _chain_code} = node, []) do
    node
  end

  # TODO warning: :crypto.hmac/3 is deprecated. It will be removed in OTP 24. Use crypto:mac/4 instead

  defp ckd_priv({key, chain_code} = node, [h | t]) do
    index = 2_147_483_648 + h
    data = <<0, key::binary, index::32>>

    <<derived_key::binary-32, child_chain::binary-32>> =
      if get_otp_version() >= 24 do
        :crypto.mac(:hmac, :sha512, chain_code, data)
      else
        :crypto.hmac(:sha512, chain_code, data)
      end

    ckd_priv({derived_key, child_chain}, t)
  end

  def hex_public_key(%Account{} = account) do
    Base.encode16(account.public_key, case: :lower)
  end

  def hex_private_key(%Account{} = account) do
    Base.encode16(account.private_key, case: :lower)
  end

  def sign(data_to_sign, %Account{} = account) do
    :crypto.sign(:eddsa, :sha256, data_to_sign, [account.private_key, :ed25519])
  end

  def sign_verify(data_to_sign, signature, %Account{} = account)
      when is_binary(data_to_sign) and is_binary(signature) and byte_size(signature) == 64 do
    :crypto.verify(:eddsa, :sha256, data_to_sign, signature, [account.public_key, :ed25519])
  end

  def sign_verify(data_to_sign, hex_signature, %Account{} = account)
      when is_binary(data_to_sign) and is_binary(hex_signature) and
             byte_size(hex_signature) == 128 do
    {:ok, signature} = Base.decode16(hex_signature, case: :mixed)
    sign_verify(data_to_sign, signature, account)
  end

  def get_otp_version do
    case Float.parse(System.otp_release()) do
      {result, ""} -> result
      {_result, _rest} -> 16.0
      :error -> 16.0
    end
  end
end
