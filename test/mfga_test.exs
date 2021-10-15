defmodule MfgaTest do
  use ExUnit.Case

  describe "order_by_fitness/1" do
    test "orders chromosomes by given fitnesses" do
      assert Mfga.sort_by_fitness([
               {["chromosome1"], 2},
               {["chromosome2"], 4},
               {["chromosome3"], 3},
               {["chromosome4"], 5},
               {["chromosome5"], 0}
             ]) ==
               [
                 {["chromosome4"], 5},
                 {["chromosome2"], 4},
                 {["chromosome3"], 3},
                 {["chromosome1"], 2},
                 {["chromosome5"], 0}
               ]
    end
  end

  describe "remove_past_fitness/1" do
    test "remove previous fitness values" do
      assert Mfga.remove_past_fitness([
               {["chromosome1"], 2},
               {["chromosome2"], 4},
               {["chromosome3"], 3},
               {["chromosome4"], 5},
               {["chromosome5"], 0}
             ]) ==
               [
                 ["chromosome1"],
                 ["chromosome2"],
                 ["chromosome3"],
                 ["chromosome4"],
                 ["chromosome5"]
               ]
    end
  end
end
