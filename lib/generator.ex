defmodule Mfga.Generator do
  def generate_chromosomes(count, size, values) do
    for _ <- 1..count, do: generate_random_sequence(size, values)
  end

  def generate_random_sequence(size, values) do
    for _ <- 1..size do
      Enum.random(values)
    end
  end
end
