import Config

config :mfga,
  chromosome_length: 40,
  chromosome_values: ~w(N E S W),
  population_size: 10000,
  mutation_chance: 0.1

import_config "#{config_env()}.exs"
