defmodule Mfga.Genetics do
  def crossover(genome1, genome2) do
    size = round(length(genome1) / 2)

    half1 = Enum.take(genome1, size)
    half2 = Enum.take(genome2, -size)

    half1 ++ half2
  end

  def mutate(genome, severity, values) do
    Enum.map(genome, fn key ->
      if Enum.random(1..100) <= severity * 100 do
        Enum.random(values)
      else
        key
      end
    end)
  end

  def calculate_fitness(all_genomes, goal) do
    Enum.map(all_genomes, fn genome ->
      {_, likeness} = calculate_genome_likeness(genome, goal)
      {genome, likeness}
    end)
  end

  def calculate_genome_likeness(genome1, genome2) do
    Enum.reduce(genome1, {0, 0}, fn key, acc ->
      if key == Enum.at(genome2, elem(acc, 0)) do
        {elem(acc, 0) + 1, elem(acc, 1) + 1}
      else
        {elem(acc, 0) + 1, elem(acc, 1)}
      end
    end)
  end
end
