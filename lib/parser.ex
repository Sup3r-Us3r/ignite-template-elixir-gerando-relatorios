defmodule GenReport.Parser do
  @month_names %{
    1 => "janeiro",
    2 => "fevereiro",
    3 => "março",
    4 => "abril",
    5 => "maio",
    6 => "junho",
    7 => "julho",
    8 => "agosto",
    9 => "setembro",
    10 => "outubro",
    11 => "novembro",
    12 => "dezembro"
  }

  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&parse_line(&1))
  end

  def parse_many_files(filenames) do
    filenames
    |> Task.async_stream(&parse_file/1)
    |> Enum.reduce([], fn {:ok, result}, acc ->
      acc ++ result
    end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(0, &String.downcase/1)
    |> List.update_at(1, &String.to_integer/1)
    |> List.update_at(2, &String.to_integer/1)
    |> List.update_at(3, &get_month_name/1)
    |> List.update_at(4, &String.to_integer/1)
  end

  defp get_month_name(month_number) do
    Map.get(
      @month_names,
      String.to_integer(month_number)
    )
  end
end
