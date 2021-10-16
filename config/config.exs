import Config

config :mfga,
  chromosome_length: 40,
  chromosome_values: ~w(N E S W),
  population_size: 1000,
  mutation_chance: 0.1,
  crossover_chance: 0.8

import_config "#{config_env()}.exs"
