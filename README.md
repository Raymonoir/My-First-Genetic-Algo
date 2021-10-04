# Mfga
MyFirstGeneticAlgorithm - A genetic program which uses a list compass points to act as a goal ie 'N', 'E', 'S', 'W', then using many iterations of random generation, genetic crossover, survival of the fittest and mutations attempting to reach that inital goal.

# Exmaple usage and output
    » iex -S mix                                                                                           8:02pm
    Erlang/OTP 23 [erts-11.2.2.4] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]

    Interactive Elixir (1.11.4) - press Ctrl+C to exit (type h() ENTER for help)
    iex(1)> Mfga.run_simulation
    {83,
     ["N", "N", "S", "S", "N", "E", "N", "E", "S", "E", "S", "N", "S", "E", "W",
      "W", "S", "E", "E", "S", "S", "S", "W", "W", "E", "W", "S", "S", "E", "E",
      "W", "E", "W", "N", "W", "S", "S", "N", "W", "S"],
     {["N", "N", "S", "S", "N", "E", "W", "E", "S", "E", "S", "N", "S", "E", "W",
       "W", "S", "E", "E", "S", "S", "S", "W", "W", "E", "W", "S", "S", "E", "E",
       "W", "E", "W", "N", "W", "S", "S", "N", "W", "S"], 39}, 17}
    iex(2)> 

Where the output is in the format: {iteration count to reach goal, goal, {best genome in previous iteration, fitness of previous best}, seconds_elapsed}

# Configuration
Default values found in config.exs:

genome_length: 40,
genome_values: ~w(N E S W),
population_size: 10000,
mutation_chance: 0.1


The fitness is found by counting the number of correct values which are in the correct positions when compared to the goal genome.
Genome values are the possible values a gene in a genome can take.
The population size is the number of genomes in a population.
The mutation chance is the likelyhood that each child gene will randomly mutate.

Run tests using 'mix test'
