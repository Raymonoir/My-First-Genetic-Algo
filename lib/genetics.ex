defmodule Mfga.Genetics do
  def crossover(chromosome1, chromosome2) do
    size = round(length(chromosome1) / 2)

    half1 = Enum.take(chromosome1, size)
    half2 = Enum.take(chromosome2, -size)

    half1 ++ half2
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
      {_total, likeness} = calculate_chromosome_fitness(chromosome, goal)
      {chromosome, likeness}
    end)
  end

  # Calculates chromosome fitness using a reduce function with a tuple as the accumulator to keep track
  # of both the total counted and the fitness between two chromosomes
  def calculate_chromosome_fitness(chromosome1, chromosome2) do
    Enum.reduce(chromosome1, {0, 0}, fn key, acc ->
      if key == Enum.at(chromosome2, elem(acc, 0)) do
        {elem(acc, 0) + 1, elem(acc, 1) + 1}
      else
        {elem(acc, 0) + 1, elem(acc, 1)}
      end
    end)
  end
end
