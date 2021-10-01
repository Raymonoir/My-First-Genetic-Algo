# Mfga
MyFirstGeneticAlgorithm - A genetic program which uses a list compass points to act as a goal ie 'N', 'E', 'S', 'W', then using many iterations of random generation, genetic crossover, survival of the fittest and mutations attempting to reach that inital goal.

# Exmaple usage and output
    > iex -S mix                                                                                          11:05pm
    Erlang/OTP 23 [erts-11.2.2.4] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]

    Compiling 3 files (.ex)
    Generated mfga app
    Interactive Elixir (1.11.4) - press Ctrl+C to exit (type h() ENTER for help)
    iex(1)> Mfga.run_simulation
    {79,
    ["S", "N", "S", "S", "N", "E", "E", "S", "N", "E", "E", "W", "N", "W", "S",
      "E", "S", "E", "N", "S", "E", "E", "N", "S", "S", "E", "N", "N", "E", "W",
      "S", "W", "E", "S", "W", "E", "S", "S", "N", "E"],
    {["S", "N", "S", "S", "N", "E", "E", "S", "N", "E", "E", "W", "N", "W", "S",
      "E", "S", "E", "N", "S", "E", "E", "E", "S", "S", "E", "N", "N", "E", "W",
      "S", "W", "E", "S", "W", "E", "S", "S", "N", "E"], 39}}
    iex(2)> 

Where the output is in the format: {iteration count, goal, {best genome in previous iteration, fitness of previous best}}



