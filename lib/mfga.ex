defmodule Mfga do
  alias Mfga.{Generator, Genetics}

  @genome_size Application.get_env(:mfga, :genome_length)
  @genome_values Application.get_env(:mfga, :genome_values)
  @population_size Application.get_env(:mfga, :population_size)
  @mutation_chance Application.get_env(:mfga, :mutation_chance)

  def run_simulation do
    start_time = System.monotonic_time(:second)

    goal = Generator.generate_random_sequence(@genome_size, @genome_values)

    initial_population =
      Generator.generate_genomes(@population_size, @genome_size, @genome_values)

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

    if max_fitness == @genome_size do
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
  defp run_iteration(all_genomes, goal) do
    result =
      Genetics.add_fitness(all_genomes, goal)
      |> sort_by_fitness()
      |> survival_of_fittest()
      |> remove_past_fitness()

    children =
      result
      |> perform_crossover()
      |> perform_mutations()

    result ++
      children ++
      Generator.generate_genomes(round(@population_size / 4), @genome_size, @genome_values)
  end

  def get_max_fitness(all_genomes) do
    Enum.max(Enum.map(all_genomes, fn {_genome, fitness} -> fitness end))
  end

  def remove_past_fitness(surviving_genomes) do
    Enum.map(surviving_genomes, fn {genome, _fitness} -> genome end)
  end

  defp survival_of_fittest(all_genomes) do
    half = round(length(all_genomes) / 2)
    Enum.take(all_genomes, half)
  end

  def sort_by_fitness(all_genomes) do
    Enum.sort(all_genomes, fn {_genome1, fitness1}, {_genome2, fitness2} ->
      fitness1 >= fitness2
    end)
  end

  defp perform_crossover(all_genomes) do
    Enum.chunk_every(all_genomes, 2)
    |> Enum.map(fn [genome1, genome2] ->
      Genetics.crossover(genome1, genome2)
    end)
  end

  defp perform_mutations(children_genomes) do
    Enum.map(children_genomes, fn child ->
      Genetics.mutate(child, @mutation_chance, @genome_values)
    end)
  end
end
