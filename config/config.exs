import Config

config :mfga,
  genome_length: 40,
  genome_values: ~w(N E S W),
  population_size: 10000,
  mutation_chance: 0.1

import_config "#{config_env()}.exs"
