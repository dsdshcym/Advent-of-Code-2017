defmodule Memory do
  def call(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> reallocate_until_repeat()
  end

  defp reallocate_until_repeat(configuration, seen_configurations \\ Map.new(), step \\ 0) do
    if Map.has_key?(seen_configurations, configuration) do
      step - Map.get(seen_configurations, configuration)
    else
      new_seen_configurations = Map.put(seen_configurations, configuration, step)
      new_configuration = reallocate(configuration)
      new_step = step + 1
      reallocate_until_repeat(new_configuration, new_seen_configurations, new_step)
    end
  end

  defp reallocate(configuration) do
    most_blocks = Enum.max(configuration)

    index = configuration |> Enum.find_index(fn blocks -> blocks == most_blocks end)

    configuration
    |> remove_at(index)
    |> allocate_from(index + 1, most_blocks)
  end

  defp remove_at(configuration, index) do
    configuration
    |> List.replace_at(index, 0)
  end

  defp allocate_from(configuration, _index, 0), do: configuration

  defp allocate_from(configuration, index, blocks) when index >= length(configuration) do
    allocate_from(configuration, 0, blocks)
  end

  defp allocate_from(configuration, index, blocks) do
    configuration
    |> List.update_at(index, &(&1 + 1))
    |> allocate_from(index + 1, blocks - 1)
  end
end

ExUnit.start()

defmodule MemoryTest do
  use ExUnit.Case

  @input "14	0	15	12	11	11	3	5	1	6	8	4	9	1	8	4"

  describe "part 1" do
    test "1 0" do
      assert Memory.call("1 0") == 2
    end

    test "2 0 0 " do
      assert Memory.call("2 0 0") == 5
    end

    test "example" do
      assert Memory.call("0 2 7 0") == 4
    end

    test "puzzle input" do
      assert Memory.call(@input) == 1037
    end
  end
end
