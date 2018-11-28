defmodule Memory do
  def new() do
    Map.new()
  end

  def allocate(memory, point, value) do
    Map.put(memory, point, value)
  end

  def allocated?(memory, current) do
    Map.has_key?(memory, current)
  end

  def value_at(memory, point) do
    Map.get(memory, point, 0)
  end
end

defmodule SpiralMemory do
  def call(input) do
    input
    |> calc_point()
  end

  defp calc_point(input) do
    traverse(1, input, {0, 0}, {0, -1}, Memory.new())
  end

  defp traverse(value, input, _, _, _) when value >= input,
    do: value

  defp traverse(value, input, current, direction, memory) do
    forward = move(current, direction)
    left = move(current, turn_left(direction))
    new_memory = Memory.allocate(memory, current, value)

    unless Memory.allocated?(memory, left) do
      new_value = calc_new_value(left, new_memory)

      traverse(new_value, input, left, turn_left(direction), new_memory)
    else
      new_value = calc_new_value(forward, new_memory)
      traverse(new_value, input, forward, direction, new_memory)
    end
  end

  defp calc_new_value(point, memory) do
    point
    |> adjacents()
    |> Enum.map(&Memory.value_at(memory, &1))
    |> Enum.sum()
  end

  defp adjacents({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1},
      {x + 1, y + 1},
      {x + 1, y - 1},
      {x - 1, y + 1},
      {x - 1, y - 1}
    ]
  end

  defp move({x, y}, {dx, dy}) do
    {x + dx, y + dy}
  end

  defp turn_left({1, 0}) do
    {0, 1}
  end

  defp turn_left({0, 1}) do
    {-1, 0}
  end

  defp turn_left({-1, 0}) do
    {0, -1}
  end

  defp turn_left({0, -1}) do
    {1, 0}
  end
end

ExUnit.start()

defmodule SpiralMemoryTest do
  use ExUnit.Case

  describe "part 2" do
    test "returns 1 for 1" do
      assert SpiralMemory.call(1) == 1
    end

    test "returns 2 for 2" do
      assert SpiralMemory.call(2) == 2
    end

    test "returns 4 for 4" do
      assert SpiralMemory.call(4) == 4
    end

    test "returns 23 for 23" do
      assert SpiralMemory.call(23) == 23
    end

    test "returns 25 for 24" do
      assert SpiralMemory.call(24) == 25
    end

    test "returns 806 for 800" do
      assert SpiralMemory.call(800) == 806
    end

    test "returns " do
      assert SpiralMemory.call(325_489) == 330_785
    end
  end
end
