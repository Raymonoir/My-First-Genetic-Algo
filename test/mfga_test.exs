defmodule MfgaTest do
  use ExUnit.Case

  describe "get_max_fitness/1" do
    test "returns the genome with the maximum fitness" do
      assert Mfga.get_max_fitness([{["genome1"], 0}, {["genome2"], 4}, {["genome3"], 6}]) == 6
    end
  end

  describe "order_by_fitness/1" do
    test "orders genomes by given fitnesses" do
      assert Mfga.order_by_fitness([
               {["genome1"], 2},
               {["genome2"], 4},
               {["genome3"], 3},
               {["genome4"], 5},
               {["genome5"], 0}
             ]) ==
               [
                 {["genome4"], 5},
                 {["genome2"], 4},
                 {["genome3"], 3},
                 {["genome1"], 2},
                 {["genome5"], 0}
               ]
    end
  end

  describe "remove_past_fitness/1" do
    test "remove previous fitness values" do
      assert Mfga.remove_past_fitness([
               {["genome1"], 2},
               {["genome2"], 4},
               {["genome3"], 3},
               {["genome4"], 5},
               {["genome5"], 0}
             ]) ==
               [
                 ["genome1"],
                 ["genome2"],
                 ["genome3"],
                 ["genome4"],
                 ["genome5"]
               ]
    end
  end
end
