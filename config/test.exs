import Config

# Print only warnings and errors during test
config :logger, level: :warn, pretty: true

# Faucet config
config :elrondex, Elrondex.Faucet,
  active: true,
  faucet_mnemonic: System.get_env("FAUCET_MNEMONIC")
