defmodule GenReport.ParserTest do
  use ExUnit.Case

  alias GenReport.Parser

  describe "parse_file/1" do
    test "parses the file" do
      file_name = "gen_report.csv"

      response =
        file_name
        |> Parser.parse_file()
        |> Enum.member?(["daniele", 7, 29, "abril", 2018])

      assert response == true
    end
  end

  describe "parse_many_files/1" do
    test "parses multiple file" do
      file_names = ["reports/part_1.csv", "reports/part_2.csv", "reports/part_3.csv"]

      response =
        file_names
        |> Parser.parse_many_files()
        |> length

      expected_length_response = 30000

      assert response == expected_length_response
    end
  end
end
