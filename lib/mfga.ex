defmodule Mfga do
  alias Mfga.{Generator, Genetics}

  @chromosome_length Application.get_env(:mfga, :chromosome_length)
  @chromosome_values Application.get_env(:mfga, :chromosome_values)
  @population_size Application.get_env(:mfga, :population_size)
  @mutation_chance Application.get_env(:mfga, :mutation_chance)
  @crossover_chance Application.get_env(:mfga, :crossover_chance)
  @tournament_k ceil(:math.sqrt(@population_size))

  # Starts simulation
  def run_simulation do
    start_time = System.monotonic_time(:second)

    IO.inspect("1")
    goal = Generator.generate_random_sequence(@chromosome_length, @chromosome_values)

    IO.inspect("2")

    initial_population =
      Generator.generate_chromosomes(@population_size, @chromosome_length, @chromosome_values)

    IO.inspect("3")
    result = run_all_interations(initial_population, goal)
    IO.inspect("4")
    end_time = System.monotonic_time(:second)

    Tuple.append(result, end_time - start_time)
  end

  # Runs all iterations until maximum fitness
  defp run_all_interations(next_pop, goal), do: run_all_interations(0, next_pop, goal)

  defp run_all_interations(count, current_pop, goal) do
    IO.inspect("5")
    new_population = run_iteration(current_pop, goal)

    IO.inspect("6")
    max_fitness = Genetics.add_fitness(new_population, goal) |> Genetics.get_max_fitness()

    IO.inspect("7")

    if max_fitness == @chromosome_length do
      previous_best = Genetics.add_fitness(current_pop, goal) |> Genetics.get_max_fitness()
      print_solutions(count, goal, previous_best)
    else
      run_all_interations(count + 1, new_population, goal)
    end
  end

  defp print_solutions(count, goal, previous_best), do: {count, goal, previous_best}

  # Runs a single iteration and generates new population
  def run_iteration(population, goal) do
    IO.inspect("8")

    pop = Genetics.add_fitness(population, goal)
    IO.inspect("9")

    pop2 = selection(pop)

    IO.inspect("10")
    pop3 = perform_crossover(pop2)
    IO.inspect("11")
    perform_mutations(pop3)
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
    probability / 100 * 2 * 100
  end

  def remove_past_fitness(surviving_chromosomes) do
    Enum.map(surviving_chromosomes, fn {chromosome, _fitness} -> chromosome end)
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
        []
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
