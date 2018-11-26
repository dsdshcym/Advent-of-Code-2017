defmodule Memory do
  def empty_memory() do
    Map.new()
  end

  def allocate(memory, point, count) do
    Map.put(memory, point, count)
  end

  def allocated?(memory, current) do
    Map.has_key?(memory, current)
  end
end

defmodule SpiralMemory do
  def call(square) do
    square
    |> calc_point()
    |> manhattan_distance()
  end

  defp calc_point(square) do
    traverse(1, square, {0, 0}, {0, -1}, Memory.empty_memory())
  end

  defp traverse(count, square, current_point, _, _) when count >= square, do: current_point

  defp traverse(count, square, current, direction, memory) do
    forward = move(current, direction)
    left = move(current, turn_left(direction))

    new_memory = Memory.allocate(memory, current, count)

    unless Memory.allocated?(memory, left) do
      traverse(count + 1, square, left, turn_left(direction), new_memory)
    else
      traverse(count + 1, square, forward, direction, new_memory)
    end
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

  defp manhattan_distance({x, y}) do
    abs(x) + abs(y)
  end
end

ExUnit.start()

defmodule SpiralMemoryTest do
  use ExUnit.Case

  describe "part 1" do
    test "returns 0 for 1" do
      assert SpiralMemory.call(1) == 0
    end

    test "returns 1 for 2" do
      assert SpiralMemory.call(2) == 1
    end

    test "returns 1 for 4" do
      assert SpiralMemory.call(4) == 1
    end

    test "returns 2 for 23" do
      assert SpiralMemory.call(23) == 2
    end

    test "returns 31 for 1024" do
      assert SpiralMemory.call(1024) == 31
    end

    test "returns " do
      assert SpiralMemory.call(325_489) == 552
    end
  end
end
