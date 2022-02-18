defmodule GenReportTest do
  use ExUnit.Case

  alias GenReport
  alias GenReport.Support.ReportFixture

  @file_name "gen_report.csv"

  describe "build/1" do
    test "When passing file name return a report" do
      response = GenReport.build(@file_name)

      assert response == ReportFixture.build()
    end

    test "When no filename was given, returns an error" do
      response = GenReport.build()

      assert response == {:error, "Insira o nome de um arquivo"}
    end
  end

  describe "build_from_many/1" do
    test "When passing a list of files return a report" do
      file_names = ["reports/part_1.csv", "reports/part_2.csv", "reports/part_3.csv"]

      response =
        file_names
        |> GenReport.build_from_many()

      assert response == ReportFixture.build()
    end

    test "When not passing a list of files returns an error" do
      response =
        ""
        |> GenReport.build_from_many()

      assert response == {:error, "Formato inválido"}
    end
  end
end
