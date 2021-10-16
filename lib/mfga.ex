defmodule Mfga do
  alias Mfga.{Generator, Genetics}

  @chromosome_length Application.get_env(:mfga, :chromosome_length)
  @chromosome_values Application.get_env(:mfga, :chromosome_values)
  @population_size Application.get_env(:mfga, :population_size)
  @mutation_chance Application.get_env(:mfga, :mutation_chance)
  @crossover_chance Application.get_env(:mfga, :crossover_chance)
  @tournament_k ceil(:math.sqrt(@population_size))

  # Starts simulation and runs all iterations untill fitness is maximised
  def run_simulation do
    start_time = System.monotonic_time(:millisecond)

    goal = Generator.generate_random_sequence(@chromosome_length, @chromosome_values)

    initial_population =
      Generator.generate_chromosomes(@population_size, @chromosome_length, @chromosome_values)

    results = run_all_interations(initial_population, goal)

    end_time = System.monotonic_time(:millisecond)

    Tuple.append(results, end_time - start_time)
  end

  # Runs all iterations until maximum fitness
  defp run_all_interations(next_pop, goal), do: run_all_interations({1, []}, next_pop, goal)

  defp run_all_interations({count, prev_fitnesses}, current_pop, goal) do
    max_fitness =
      Genetics.add_fitness(current_pop, goal)
      |> Genetics.get_max_fitness()

    if max_fitness == @chromosome_length do
      print_solutions(count, prev_fitnesses)
    else
      new_population = run_iteration(current_pop, goal)
      run_all_interations({count + 1, prev_fitnesses ++ [max_fitness]}, new_population, goal)
    end
  end

  defp print_solutions(count, prev_fitnesses), do: {count, prev_fitnesses}

  # Runs a single iteration and generates new population
  def run_iteration(population, goal) do
    Genetics.add_fitness(population, goal)
    |> selection()
    |> perform_crossover()
    |> perform_mutations()
  end

  defp selection(population) do
    Enum.map(population, fn _ ->
      Genetics.tournament_selection(
        population,
        @tournament_k
      )
    end)
  end

  defp get_chunked_crossover_chance(probability) do
    probability * 2 * 100
  end

  def selected?(likelihood) do
    if Enum.random(1..100) <= likelihood, do: true, else: false
  end

  def sort_by_fitness(population) do
    Enum.sort(population, fn {_chromosome1, fitness1}, {_chromosome2, fitness2} ->
      fitness1 >= fitness2
    end)
  end

  defp perform_crossover(population) do
    select_parents(population)
    |> Enum.map(fn {{chrom1, _fit1}, {chrom2, _fit2}} ->
      if selected?(get_chunked_crossover_chance(@crossover_chance)) do
        Genetics.crossover(chrom1, chrom2)
      else
        [chrom1, chrom2]
      end
    end)
    |> Enum.concat()
  end

  def select_parents(population) do
    for _ <- 1..round(length(population) / 2) do
      {Genetics.tournament_selection(population, @tournament_k),
       Genetics.tournament_selection(population, @tournament_k)}
    end
  end

  defp perform_mutations(children_chromosomes) do
    Enum.map(children_chromosomes, fn child ->
      Genetics.mutate(child, @mutation_chance, @chromosome_values)
    end)
  end
end
