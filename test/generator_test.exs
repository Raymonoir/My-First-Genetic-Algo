defmodule Mfga.GeneratorTest do
  use ExUnit.Case
  alias Mfga.Generator

  test "generated list is correct length" do
    sequence = Generator.generate_random_sequence(10, ~w(N E S W))
    assert length(sequence) == 10
  end

  test "generated list only contains provided values" do
    sequence = Generator.generate_random_sequence(10, ~w(N E S W))
    refute Enum.any?(sequence, fn key -> key not in ~w(N E S W) end)
  end

  test "generate a list of chromosomes" do
    chromosomes_list = Generator.generate_chromosomes(3, 4, ~w(N))
    [head | _rest] = chromosomes_list

    assert length(chromosomes_list) == 3
    assert length(head) == 4
    assert head == ~w(N N N N)
  end
end
