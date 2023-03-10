import Config

# Print debug and errors logs during IEx session
config :logger, level: :debug

# Faucet config
config :elrondex, Elrondex.Faucet,
  active: true,
  faucet_mnemonic: System.get_env("FAUCET_MNEMONIC")
