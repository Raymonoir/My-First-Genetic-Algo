defmodule Mfga do
  alias Mfga.{Generator, Genetics}

  @chromosome_size Application.get_env(:mfga, :chromosome_length)
  @chromosome_values Application.get_env(:mfga, :chromosome_values)
  @population_size Application.get_env(:mfga, :population_size)
  @mutation_chance Application.get_env(:mfga, :mutation_chance)

  def run_simulation do
    start_time = System.monotonic_time(:second)

    goal = Generator.generate_random_sequence(@chromosome_size, @chromosome_values)

    initial_population =
      Generator.generate_chromosomes(@population_size, @chromosome_size, @chromosome_values)

    next = run_iteration(initial_population, goal)

    result = run_all_interations(next, goal)
    end_time = System.monotonic_time(:second)

    Tuple.append(result, end_time - start_time)
  end

  # Runs all iterations until maximum fitness
  defp run_all_interations(next_pop, goal), do: run_all_interations(0, next_pop, goal)

  defp run_all_interations(count, current_pop, goal) do
    new_next = run_iteration(current_pop, goal)

    max_fitness =
      Genetics.add_fitness(new_next, goal)
      |> get_max_fitness()

    if max_fitness == @chromosome_size do
      [fittest | _tail] =
        Genetics.add_fitness(current_pop, goal)
        |> sort_by_fitness()

      print_solutions(count, goal, fittest)
    else
      run_all_interations(count + 1, new_next, goal)
    end
  end

  defp print_solutions(count, goal, previous_best), do: {count, goal, previous_best}

  # Runs a single iteration
  defp run_iteration(all_chromosomes, goal) do
    result =
      Genetics.add_fitness(all_chromosomes, goal)
      |> sort_by_fitness()
      |> survival_of_fittest()
      |> remove_past_fitness()

    children =
      result
      |> perform_crossover()
      |> perform_mutations()

    result ++
      children ++
      Generator.generate_chromosomes(
        round(@population_size / 4),
        @chromosome_size,
        @chromosome_values
      )
  end

  def get_max_fitness(all_chromosomes) do
    Enum.max(Enum.map(all_chromosomes, fn {_chromosome, fitness} -> fitness end))
  end

  def remove_past_fitness(surviving_chromosomes) do
    Enum.map(surviving_chromosomes, fn {chromosome, _fitness} -> chromosome end)
  end

  defp survival_of_fittest(all_chromosomes) do
    half = round(length(all_chromosomes) / 2)
    Enum.take(all_chromosomes, half)
  end

  def sort_by_fitness(all_chromosomes) do
    Enum.sort(all_chromosomes, fn {_chromosome1, fitness1}, {_chromosome2, fitness2} ->
      fitness1 >= fitness2
    end)
  end

  defp perform_crossover(all_chromosomes) do
    Enum.chunk_every(all_chromosomes, 2)
    |> Enum.map(fn [chromosome1, chromosome2] ->
      Genetics.crossover(chromosome1, chromosome2)
    end)
  end

  defp perform_mutations(children_chromosomes) do
    Enum.map(children_chromosomes, fn child ->
      Genetics.mutate(child, @mutation_chance, @chromosome_values)
    end)
  end
end
