defmodule SpiralMemory do
  def call(square) do
    square
    |> calc_point()
    |> manhattan_distance()
  end

  defp calc_point(square) do
    traverse(1, square, {0, 0}, {0, -1}, empty_memory())
  end

  defp traverse(count, square, current_point, _, _) when count >= square, do: current_point

  defp traverse(count, square, current, direction, memory) do
    forward = move(current, direction)
    left = move(current, turn_left(direction))

    unless allocated?(memory, left) do
      traverse(count + 1, square, left, turn_left(direction), allocate(memory, current))
    else
      traverse(count + 1, square, forward, direction, allocate(memory, current))
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

  defp empty_memory() do
    MapSet.new()
  end

  defp allocate(memory, point) do
    MapSet.put(memory, point)
  end

  defp allocated?(memory, current) do
    MapSet.member?(memory, current)
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
