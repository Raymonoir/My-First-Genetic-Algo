defmodule Mfga.GeneticsTest do
  use ExUnit.Case
  alias Mfga.Genetics

  describe "crossover/3" do
    test "crossover function joins two halves of two geneomes" do
      list1 = for i <- 1..10, do: i
      list2 = for j <- 11..20, do: j

      assert Genetics.crossover(
               list1,
               list2
             ) == [1, 2, 3, 4, 5, 16, 17, 18, 19, 20]
    end
  end

  describe "calculate_fitness/2" do
    test "calculates correct fitness value for multiple genomes" do
      assert Genetics.calculate_fitness([[1, 2, 3, 4], [5, 6, 7, 8]], [1, 2, 7, 8]) == [
               {[1, 2, 3, 4], 2},
               {[5, 6, 7, 8], 2}
             ]

      list = ["N", "E", "S", "W"]

      assert Genetics.calculate_fitness(
               [list, list, list],
               list
             ) == [
               {list, 4},
               {list, 4},
               {list, 4}
             ]
    end
  end

  describe "mutate/3" do
    test "0 severity returns no genes mutations" do
      assert get_mutation_average(0) == 0
    end

    test "1 severity returns all genes mutated" do
      assert get_mutation_average(1) == 1
    end

    test "0.25 severity returns 1/4 of the genes mutated on average" do
      assert get_mutation_average(0.25) < 0.26
      assert get_mutation_average(0.25) > 0.24
    end

    test "0.5 severity retruns half of the genes mutated on average" do
      assert get_mutation_average(0.5) < 0.51
      assert get_mutation_average(0.5) > 0.49
    end

    test "0.75 severity retruns 3.4 of the genes mutated on average" do
      assert get_mutation_average(0.75) < 0.76
      assert get_mutation_average(0.75) > 0.74
    end

    # Function to get average mutations
    # Uses a genome of 100 genes and repeats 1000 times
    defp get_mutation_average(severity) do
      long_list = for i <- 1..100, do: i

      Enum.sum(
        for _ <- 1..1000 do
          {total, likeness} =
            Genetics.calculate_genome_likeness(
              Genetics.mutate(long_list, severity, ~w(N)),
              long_list
            )

          (total - likeness) / total
        end
      ) / 1000
    end
  end
end
