[![Hex.pm](https://img.shields.io/hexpm/v/elrondex.svg)](https://hex.pm/packages/elrondex)

Welcome to Elrondex. 

Elixir libraries to interact with Elrond Blockchain ⚡ and its components $EGLD, Arwen, WASM, DeFI, SC, ESDTs, NFTs, SFTs, $MEX, DEX, AMM

This is **DRAFT** code it will definitely be changed in the near future. 


## Installation

Add `elrondex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elrondex, "~> 0.1.0"}
  ]
end
```

## Examples

### Transfer 1 EGLD from Bob account to Alice account on testnet network

```elixir
alias Elrondex.{Account, Transaction, Network, REST}

network = Network.testnet()

# 24 words
bob_mnemonic = "quick alone describe ..."
alice_address = "erd18n5zgmet82jvqag9n8pcvzdzlgqr3jhqxld2z6nwxzekh4cwt6ps87zfmu"

bob_mnemonic 
  |> Account.from_mnemonic()
  |> Transaction.transaction(alice_address, 1_000_000_000_000_000_000)
  |> Transaction.prepare(network)
  |> Transaction.sign()
  |> REST.post_transaction_send()

{:ok, "5e3bd0cc962a1eb2ad68b8610d8ae4ae9255c041e1d73ae4d23caf9956dae9c4"}
```

### Get WEGLD/USDC pair info from Maiar DEX on mainnet

```elixir
mainnet = Elrondex.Network.mainnet()
pair_address = "erd1qqqqqqqqqqqqqpgqeel2kumf0r8ffyhth7pqdujjat9nx0862jpsg2pqaq"

Elrondex.Sc.PairSc.get_pair(pair_address, mainnet)

{:ok,
 %Elrondex.Pair{
   address: "erd1qqqqqqqqqqqqqpgqeel2kumf0r8ffyhth7pqdujjat9nx0862jpsg2pqaq",
   first_decimals: 18,
   first_token: "WEGLD-bd4d79",
   lp_decimals: 18,
   lp_token: "EGLDUSDC-594e5e",
   name: nil,
   second_decimals: 6,
   second_token: "USDC-c76f1f"
 }}
```

<!--
**elrondex/elrondex** is a ✨ _special_ ✨ repository because its `README.md` (this file) appears on your GitHub profile.

Here are some ideas to get you started:

- 🔭 I’m currently working on ...
- 🌱 I’m currently learning ...
- 👯 I’m looking to collaborate on ...
- 🤔 I’m looking for help with ...
- 💬 Ask me about ...
- 📫 How to reach me: ...
- 😄 Pronouns: ...
- ⚡ Fun fact: ...
-->
