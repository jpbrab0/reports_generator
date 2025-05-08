defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @available_foods [
    "pizza",
    "açaí",
    "hambúrguer",
    "esfirra",
    "churrasco",
    "pastel",
    "prato_feito",
    "sushi"
  ]

  @options ["users", "foods"]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build_from_many(filenames) when not is_list(filenames) do
    {:error, "Please provide a list of strings"}
  end

  # parallelism
  def build_from_many(filenames) do
    result =
      filenames
      |> Task.async_stream(&build/1)
      |> Enum.reduce(report_acc(), fn {_, result}, report -> sum_reports(report, result) end)

    {:ok, result}
  end

  def fetch_higher(report, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_key, value} -> value end)}
  end

  def fetch_higher(_, _) do
    {:error, "Invalid option."}
  end

  defp sum_reports(%{"foods" => foods1, "users" => users1}, %{
         "foods" => foods2,
         "users" => users2
       }) do
    foods = merge_maps(foods1, foods2)
    users = merge_maps(users1, users2)

    build_report(foods, users)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _, value1, value2 -> value1 + value2 end)
  end

  defp sum_values([id, food_name, price], %{"users" => users, "foods" => foods}) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    build_report(foods, users)
  end

  defp report_acc do
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
    foods = Enum.into(@available_foods, %{}, &{&1, 0})

    build_report(foods, users)
  end

  defp build_report(foods, users), do: %{"users" => users, "foods" => foods}
end
