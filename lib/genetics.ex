defmodule Mfga.Genetics do
  def crossover(chromosome1, chromosome2) do
    crossover_point = get_crossover_point(length(chromosome1))

    {chromosome1_half1, chromosome1_half2} = Enum.split(chromosome1, crossover_point)
    {chromosome2_half1, chromosome2_half2} = Enum.split(chromosome2, crossover_point)

    [chromosome1_half1 ++ chromosome2_half2, chromosome2_half1 ++ chromosome1_half2]
  end

  #     1                            length - 1
  # | N | W | S | S | W | E | N | W | S | E |
  defp get_crossover_point(length) do
    Enum.random(1..(length - 1))
  end

  def mutate(chromosome, severity, values) do
    Enum.map(chromosome, fn key ->
      if Enum.random(1..100) <= severity * 100 do
        Enum.random(values)
      else
        key
      end
    end)
  end

  # Adds fitness to chromosome in the form of {chromosome, fitness}
  def add_fitness(population, goal) do
    Enum.map(population, fn chromosome ->
      {_total, fitness} = calculate_chromosome_fitness(chromosome, goal)
      {chromosome, fitness}
    end)
  end

  # Calculates chromosome fitness using a reduce function with a tuple as the accumulator to keep track
  # of both the total counted and the fitness between two chromosomes
  def calculate_chromosome_fitness(chromosome1, chromosome2) do
    Enum.reduce(chromosome1, {0, 0}, fn gene, {total, fitness} ->
      if gene == Enum.at(chromosome2, total) do
        {total + 1, fitness + 1}
      else
        {total + 1, fitness}
      end
    end)
  end
end
