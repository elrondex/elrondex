defmodule Elrondex.PairTest do
  alias Elrondex.{Account, Transaction, Network, REST, ESDT}

  use ExUnit.Case

  @wrap_egld_address "erd1qqqqqqqqqqqqqpgqfj3z3k4vlq7dc2928rxez0uhhlq46s6p4mtqerlxhc"
  # Pair Contract
  @pair_egldbusd_address "erd1qqqqqqqqqqqqqpgq3gmttefd840klya8smn7zeae402w2esw0n4sm8m04f"
  # "BUSD-05b16f"
  # "WEGLD-88600a"
  # "EGLDBUSD-855259"

  # Price 83.843 EGLD/BUSD

  def pair_transaction(data, gas_limit \\ 80_000_000) do
    devnet = Network.get(:devnet)

    mnemonic =
      "cost turn honey genre mercy reunion start lion snap box endorse horse cross destroy figure acid glue virtual taxi vital finish option inject inherit"

    value = "0"

    tx_hash =
      mnemonic
      |> Account.from_mnemonic()
      |> Transaction.transaction(@pair_egldbusd_address, value, data)
      |> Map.put(:gasLimit, gas_limit)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
  end

  @tag :skip
  test "getAmountIn 100 BUSD require 1.19 EGLD " do
    # token_in = ESDT.hex_encode("WEGLD-88600a")
    token_in = ESDT.hex_encode("BUSD-05b16f")
    amount_in = ESDT.hex_encode(100_000_000_000_000_000_000)
    data = "getAmountIn@" <> token_in <> "@" <> amount_in

    pair_transaction(data)
    # getAmountIn@425553442d303562313666@056bc75e2d63100000
    # @ok@109a16ae8edef51d -> 1_196293_589997_384989

    # getAmountIn@425553442d303562313666@056bc75e2d63100000
    # @ok@109a16ae8edef51d -> 1_196293_589997_384989
  end

  @tag :skip
  test "getAmountIn 100000 BUSD require 1197.57 EGLD " do
    # token_in = ESDT.hex_encode("WEGLD-88600a")
    token_in = ESDT.hex_encode("BUSD-05b16f")
    amount_in = ESDT.hex_encode(1_000_000_000_000_000_000_000_000)
    data = "getAmountIn@" <> token_in <> "@" <> amount_in

    pair_transaction(data)
    # getAmountIn@425553442d303562313666@152d02c7e14af6800000
    # @ok@40ebb2c20437ef7ab2 1197_575471_185552_964274

    # getAmountIn@425553442d303562313666@d3c21bcecceda1000000
    # @ok@028f8903359e11d78fe0 -> 12092 490162 040903 012320
    # 1_000_000 BUSD require 12092.49 EGLD
  end

  @tag :skip
  test "getAmountIn 1 EGLD require x BUSD " do
    token_in = ESDT.hex_encode("WEGLD-88600a")
    # token_in = ESDT.hex_encode("BUSD-05b16f")
    amount_in = ESDT.hex_encode(1_000_000_000_000_000_000)
    data = "getAmountIn@" <> token_in <> "@" <> amount_in

    pair_transaction(data)
    # getAmountIn@5745474c442d383836303061@0de0b6b3a7640000
    # @ok@048f0f3cc44bf2d147 -> 84.095 501 180 698 022 215 
  end

  @tag :skip
  test "getLpTokenIdentifier" do
    devnet = Network.get(:devnet)

    mnemonic =
      "cost turn honey genre mercy reunion start lion snap box endorse horse cross destroy figure acid glue virtual taxi vital finish option inject inherit"

    address = "erd1ut3wf73j30x6l0suvn7dyequ6yex7lw08k8pup2l25027ee3xl2qenfh8m"

    value = "0"
    data = "getLpTokenIdentifier"

    tx_hash =
      mnemonic
      |> Account.from_mnemonic()
      |> Transaction.transaction(@pair_egldbusd_address, value, data)
      |> Map.put(:gasLimit, 80_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
    # @ok@45474c44425553442d383535323539
    # "EGLDBUSD-855259"
  end

  @tag :skip
  test "getEquivalent" do
    devnet = Network.get(:devnet)

    mnemonic =
      "cost turn honey genre mercy reunion start lion snap box endorse horse cross destroy figure acid glue virtual taxi vital finish option inject inherit"

    address = "erd1ut3wf73j30x6l0suvn7dyequ6yex7lw08k8pup2l25027ee3xl2qenfh8m"

    value = "0"
    # token_in = ESDT.hex_encode("WEGLD-88600a")
    token_in = ESDT.hex_encode("BUSD-05b16f")

    amount_in = ESDT.hex_encode(1_000_000_000_000_000_000)
    data = "getEquivalent@" <> token_in <> "@" <> amount_in

    tx_hash =
      mnemonic
      |> Account.from_mnemonic()
      |> Transaction.transaction(@pair_egldbusd_address, value, data)
      |> Map.put(:gasLimit, 80_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()

    IO.inspect(tx_hash)
    # 1 WrapEGDL = 83.843 BUSD
    # getEquivalent@5745474c442d383836303061@0de0b6b3a7640000
    # @ok@048b8fd3862e16d712 -> 83843465361032140562
    # 83_843 465 361 032 140 562
    #
    # 2 BUSD = 0.011 EGDL
    # getEquivalent@425553442d303562313666@0de0b6b3a7640000
    # @ok@2a5f8847416f46 -> 11926987937509190
    # 00_011 926 987 937 509 190
  end

  @tag :skip
  test "check wrapEgld" do
    devnet = Network.devnet()

    # My 
    address = "erd1ut3wf73j30x6l0suvn7dyequ6yex7lw08k8pup2l25027ee3xl2qenfh8m"
    # Example
    # address = "erd1j9w8n9x9q8rly35t7k6a49956a775f08rjda0chs743gu7ypar9q802l4r"
    # 
    # address = @wrap_egld_address
    # address = @pair_egldbusd_address

    {:ok, esdt} = REST.get_address_esdt(devnet, address)
    IO.inspect(esdt)

    esdt
    |> Map.keys()
    |> Enum.join("\n")
    |> IO.inspect()
  end

  @tag :skip
  test "getReservesAndTotalSupply" do
    data = "getReservesAndTotalSupply"
    pair_transaction(data)
    # @ok@ebb7f6256767528ba384@4d33632c8ee6c11422b656@d721c878148521edf04a
    #  1,113,149 614336 256405 906308
    # 93,329,958 239373 396906 522198
    #    1015931 981689 772959 461450 ?
  end

  @tag :skip
  test "swapTokensFixedInput 100 BUSD from 10 EGLD " do
    token_in = ESDT.hex_encode("BUSD-05b16f")
    amount_in = ESDT.hex_encode(100_000_000_000_000_000_000)

    # token_out = ESDT.hex_encode("WEGLD-88600a")
    # amount_out = ESDT.hex_encode(10_000_000_000_000_000_000)

    # data = "swapTokensFixedInput@#{token_in}@#{amount_in}@#{token_out}@#{amount_out}"
    data = "swapTokensFixedInput@#{token_in}@#{amount_in}"

    pair_transaction(data)
    # getAmountIn@425553442d303562313666@056bc75e2d63100000
    # @ok@109a16ae8edef51d -> 1_196293_589997_384989

    # getAmountIn@425553442d303562313666@056bc75e2d63100000
    # @ok@109a16ae8edef51d -> 1_196293_589997_384989
  end

  @tag :skip
  test "Example" do
    # Example
    # Main TR
    # ESDTTransfer@
    #   5745474c442d383836303061@ -> WEGLD-88600a
    #   0de0b6b3a7640000@ -> 1 000000 000000 000000
    # 73776170546f6b656e734669786564496e707574@ -> swapTokensFixedInput
    # 425553442d303562313666@ -> BUSD-05b16f
    # 047e3486bfa0c1a000 -> 82 881018 000000 000000
    #
    # Tr1: Addr -> Pair
    # swapTokensFixedInput@425553442d303562313666@047e3486bfa0c1a000
    # BUSD-05b16f 82 881018 000000 000000
    #
    # Tr2: Pair -> Addr
    # ESDTTransfer@425553442d303562313666@0489d2e38a175b8911@
    # BUSD-05b16f 83 718226 605380 438289
    #
    # Tr3: Pair -> Addr
    # @ok
    # 
    # Tr4: Pair -> Lp
    # ESDTTransfer@
    #  5745474c442d383836303061@ -> WEGLD-88600a
    #  038d7ea4c68000@ -> 0,001000 000000 000000
    #  737761704e6f466565416e64466f7277617264@ -> swapNoFeeAndForward
    #  4d45582d623662623764@ -> MEX-b6bb7d
    #  000000000000000005005c2b121777ef671d3a49958792528c8cebce46c87ceb
    #
  end

  @tag :skip
  test "swapTokensFixedInput 1 EGLD to min 80 BUSD" do
    token_in = ESDT.hex_encode("WEGLD-88600a")
    amount_in = ESDT.hex_encode(1_000_000_000_000_000_000)

    token_out = ESDT.hex_encode("BUSD-05b16f")
    amount_out = ESDT.hex_encode(80_000_000_000_000_000_000)

    swap = ESDT.hex_encode("swapTokensFixedInput")

    # data = "swapTokensFixedInput@#{token_in}@#{amount_in}@#{token_out}@#{amount_out}"
    data = "ESDTTransfer@#{token_in}@#{amount_in}@#{swap}@#{token_out}@#{amount_out}"

    pair_transaction(data, 100_000_000)
  end

  @tag :skip
  test "swapTokensFixedInput 1 EGLD to min 90 BUSD" do
    token_in = ESDT.hex_encode("WEGLD-88600a")
    amount_in = ESDT.hex_encode(1_000_000_000_000_000_000)

    token_out = ESDT.hex_encode("BUSD-05b16f")
    amount_out = ESDT.hex_encode(70_000_000_000_000_000_000)

    swap = ESDT.hex_encode("swapTokensFixedInput")

    # data = "swapTokensFixedInput@#{token_in}@#{amount_in}@#{token_out}@#{amount_out}"
    data = "ESDTTransfer@#{token_in}@#{amount_in}@#{swap}@#{token_out}@#{amount_out}"

    pair_transaction(data, 100_000_000)
    # ESDTTransfer@5745474c442d383836303061@0de0b6b3a7640000@75736572206572726f72
    # WEGLD-88600a, 1 000000 000000 000000, user error

    # 79 704623 977399 012979
  end

  @tag :skip
  test "swapTokensFixedInput 80 BUSD to min 1 WEGLD" do
    token_in = ESDT.hex_encode("BUSD-05b16f")
    amount_in = ESDT.hex_encode(80_000_000_000_000_000_000)

    token_out = ESDT.hex_encode("WEGLD-88600a")
    amount_out = ESDT.hex_encode(800_000_000_000_000_000)

    swap = ESDT.hex_encode("swapTokensFixedInput")

    # data = "swapTokensFixedInput@#{token_in}@#{amount_in}@#{token_out}@#{amount_out}"
    data = "ESDTTransfer@#{token_in}@#{amount_in}@#{swap}@#{token_out}@#{amount_out}"

    pair_transaction(data, 100_000_000)
    # ESDTTransfer@5745474c442d383836303061@0de0b6b3a7640000@75736572206572726f72
    # WEGLD-88600a, 1 000000 000000 000000, user error

    # 79 704623 977399 012979
  end

  @tag :skip
  test "swapTokensFixedOutput for XX BUSD to get fix 1 WEGLD" do
    token_in = ESDT.hex_encode("BUSD-05b16f")
    amount_in = ESDT.hex_encode(90_000_000_000_000_000_000)

    token_out = ESDT.hex_encode("WEGLD-88600a")
    amount_out = ESDT.hex_encode(1_000_000_000_000_000_000)

    swap = ESDT.hex_encode("swapTokensFixedOutput")

    # data = "swapTokensFixedInput@#{token_in}@#{amount_in}@#{token_out}@#{amount_out}"
    data = "ESDTTransfer@#{token_in}@#{amount_in}@#{swap}@#{token_out}@#{amount_out}"

    pair_transaction(data, 100_000_000)
    # Pait -> Addr
    # ESDTTransfer@425553442d303562313666@8c48fd53b0747a06@
    # BUSD-05b16f, 10 108607 899517 614598

    # Pait -> Addr
    # ESDTTransfer@5745474c442d383836303061@0de0b6b3a7640000@
    # WEGLD-88600a, 1 000000 000000 000000
  end

  @tag :skip
  test "addLiquidity" do
    # BUSD
    first_token_amount_desired = ESDT.hex_encode(1_000_000_000_000_000_000)
    second_token_amount_desired = ESDT.hex_encode(60_000_000_000_000_000_000)

    first_token_amount_min = ESDT.hex_encode(900_000_000_000_000_000)
    second_token_amount_min = ESDT.hex_encode(54_000_000_000_000_000_000)

    data =
      "addLiquidity@#{first_token_amount_desired}@#{second_token_amount_desired}@#{first_token_amount_min}@#{second_token_amount_min}"

    pair_transaction(data, 100_000_000)

    # Example: 
    # addLiquidity@07e973c92e5787ec0000@01dccbe7a7b2c0fe248000@07e76d4523ccb1008000@01dc51d851c5435c18b000
    # addLiquidity
    #   37363 000000 000000 000000
    # 2251607 827400 000000 000000
    #   37325 637000 000000 000000
    # 2249356 219572 600000 000000
    # 
    # "WEGLD-88600a"
    # "EGLDBUSD-855259" is EGLDBUSDLP

    # Success
    # addLiquidity@0de0b6b3a7640000@0340aad21b3b700000@0c7d713b49da0000@02ed6689e54f180000
    # ESDTTransfer@5745474c442d383836303061@0df02cc254808e7c@
    #    ESDTTransfer, WEGLD-88600a, 1 004351 930056 609404
    # ESDTTransfer@425553442d303562313666@0796e3ea3f8ab00000@
    #    ESDTTransfer, BUSD-05b16f, 140 000000 000000 000000
    # @ok@0000000f45474c44425553442d383535323539000000080aafe033098bc02b@0000000c5745474c442d383836303061000000080dd140a4fa477184@0000000b425553442d303562313666000000090340aad21b3b700000
    # ??
    # ESDTTransfer@45474c44425553442d383535323539@0aafe033098bc02b@
    #    ESDTTransfer, EGLDBUSD-855259, 0 770080 571111 751723
    # 
    # Account + 
    # EGLDBUSDLP 0.770080571111751723 EGLDBUSD-855259
  end

  @tag :skip
  test "acceptEsdtPayment for 2 WEGLD" do
    token_in = ESDT.hex_encode("WEGLD-88600a")
    amount_in = ESDT.hex_encode(2_000_000_000_000_000_000)

    acceptEsdtPayment = ESDT.hex_encode("acceptEsdtPayment")

    data = "ESDTTransfer@#{token_in}@#{amount_in}@#{acceptEsdtPayment}"

    pair_transaction(data, 100_000_000)
  end

  @tag :skip
  test "acceptEsdtPayment for 200 BUSD" do
    token_in = ESDT.hex_encode("BUSD-05b16f")
    amount_in = ESDT.hex_encode(200_000_000_000_000_000_000)

    acceptEsdtPayment = ESDT.hex_encode("acceptEsdtPayment")

    data = "ESDTTransfer@#{token_in}@#{amount_in}@#{acceptEsdtPayment}"

    pair_transaction(data, 100_000_000)
  end

  @tag :skip
  test "reclaimTemporaryFunds" do
    data = "reclaimTemporaryFunds"
    pair_transaction(data, 100_000_000)
  end
end
