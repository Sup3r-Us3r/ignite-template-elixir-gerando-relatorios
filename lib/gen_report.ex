alias GenReport.Parser

defmodule GenReport do
  @months_acc %{
    "janeiro" => 0,
    "fevereiro" => 0,
    "março" => 0,
    "abril" => 0,
    "maio" => 0,
    "junho" => 0,
    "julho" => 0,
    "agosto" => 0,
    "setembro" => 0,
    "outubro" => 0,
    "novembro" => 0,
    "dezembro" => 0
  }

  def build(), do: {:error, "Insira o nome de um arquivo"}

  def build(filename) do
    parsed_file = Parser.parse_file(filename)

    Enum.reduce(
      parsed_file,
      report_acc(parsed_file),
      fn line, report -> sum_values(line, report) end
    )
  end

  defp report_acc(parsed_file) do
    all_hours =
      parsed_file
      |> Enum.map(fn elem -> List.first(elem) end)
      |> Map.new(fn k -> {k, 0} end)

    hours_per_month =
      parsed_file
      |> Enum.map(fn elem -> List.first(elem) end)
      |> Map.new(fn k -> {k, @months_acc} end)

    hours_per_year =
      parsed_file
      |> Enum.map(fn elem -> List.first(elem) end)
      |> Map.new(fn k ->
        {
          k,
          Map.new(2016..2020, &{&1, 0})
        }
      end)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp sum_values(
         line,
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         } = report
       ) do
    all_hours = sum_values_all_hours(line, all_hours)
    hours_per_month = sum_values_hours_per_month(line, hours_per_month)
    hours_per_year = sum_values_per_year(line, hours_per_year)

    %{
      report
      | "all_hours" => all_hours,
        "hours_per_month" => hours_per_month,
        "hours_per_year" => hours_per_year
    }
  end

  defp sum_values_all_hours([name, amount_hours, _day, _month, _year], all_hours) do
    Map.put(all_hours, name, all_hours[name] + amount_hours)
  end

  defp sum_values_hours_per_month([name, amount_hours, _day, month, _year], hours_per_month) do
    sum_values_by_month = %{
      hours_per_month[name]
      | month => hours_per_month[name][month] + amount_hours
    }

    %{hours_per_month | name => sum_values_by_month}
  end

  defp sum_values_per_year([name, amount_hours, _day, _month, year], hours_per_year) do
    sum_values_by_year = %{
      hours_per_year[name]
      | year => hours_per_year[name][year] + amount_hours
    }

    %{hours_per_year | name => sum_values_by_year}
  end
end
