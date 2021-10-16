defmodule Mfga.GeneticsTest do
  use ExUnit.Case
  alias Mfga.Genetics

  describe "tournament_selection/2" do
    test "tournament selection with k=1 is random" do
      :rand.seed(:exsss, {105, 105, 105})

      assert {[4, 5, 6], 2} ==
               Genetics.tournament_selection(chromosome_list(), 1)
    end

    test "tournment selection with k=pop_size is elitism" do
      # We need this because we select k random individuals,
      # there is no guarantee the same individual is chosen twice
      :rand.seed(:exsss, {105, 105, 105})

      assert {[25, 26, 27], 9} ==
               Genetics.tournament_selection(
                 chromosome_list(),
                 length(chromosome_list())
               )
    end

    test "tournament selection with k = sqrt(pop_size)" do
      :rand.seed(:exsss, {105, 105, 105})

      assert {[7, 8, 9], 3} ==
               Genetics.tournament_selection(
                 chromosome_list(),
                 round(:math.sqrt(length(chromosome_list())))
               )
    end
  end

  describe "get_max_fitness/1" do
    test "returns the chromosome with the maximum fitness" do
      assert Genetics.get_max_fitness(chromosome_list()) == 9
    end
  end

  describe "crossover/3" do
    test "crossover function joins two halves of two geneomes" do
      list1 = for i <- 1..10, do: i
      list2 = for j <- 11..20, do: j

      :rand.seed(:exsss, {105, 105, 105})

      assert Genetics.crossover(
               list1,
               list2
             ) == [[1, 2, 3, 4, 15, 16, 17, 18, 19, 20], [11, 12, 13, 14, 5, 6, 7, 8, 9, 10]]
    end
  end

  describe "add_fitness/2" do
    test "calculates correct fitness value for multiple chromosomes" do
      assert Genetics.add_fitness([[1, 2, 3, 4], [5, 6, 7, 8]], [1, 2, 7, 8]) == [
               {[1, 2, 3, 4], 2},
               {[5, 6, 7, 8], 2}
             ]

      list = ["N", "E", "S", "W"]

      assert Genetics.add_fitness(
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
    # Uses a chromosome of 100 genes and repeats 1000 times
    defp get_mutation_average(severity) do
      long_list = for i <- 1..100, do: i

      Enum.sum(
        for _ <- 1..1000 do
          {total, fitness} =
            Genetics.calculate_chromosome_fitness(
              Genetics.mutate(long_list, severity, ~w(N)),
              long_list
            )

          (total - fitness) / total
        end
      ) / 1000
    end

    def chromosome_list() do
      [
        {[1, 2, 3], 1},
        {[4, 5, 6], 2},
        {[7, 8, 9], 3},
        {[10, 11, 12], 4},
        {[13, 14, 15], 5},
        {[16, 17, 18], 6},
        {[19, 20, 21], 7},
        {[22, 23, 24], 8},
        {[25, 26, 27], 9}
      ]
    end
  end
end
