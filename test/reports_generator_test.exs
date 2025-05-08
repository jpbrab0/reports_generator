defmodule ReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "Builds the report" do
      filename = "report_test.csv"

      response =
        filename
        |> ReportsGenerator.build()

      expected_response = %{
        "foods" => %{
          "açaí" => 1,
          "churrasco" => 2,
          "esfirra" => 3,
          "hambúrguer" => 2,
          "pastel" => 0,
          "pizza" => 2,
          "prato_feito" => 0,
          "sushi" => 0
        },
        "users" => %{
          "1" => 48,
          "10" => 36,
          "11" => 0,
          "12" => 0,
          "13" => 0,
          "14" => 0,
          "15" => 0,
          "16" => 0,
          "17" => 0,
          "18" => 0,
          "19" => 0,
          "2" => 45,
          "20" => 0,
          "21" => 0,
          "22" => 0,
          "23" => 0,
          "24" => 0,
          "25" => 0,
          "26" => 0,
          "27" => 0,
          "28" => 0,
          "29" => 0,
          "3" => 31,
          "30" => 0,
          "4" => 42,
          "5" => 49,
          "6" => 18,
          "7" => 27,
          "8" => 25,
          "9" => 24
        }
      }

      assert response == expected_response
    end
  end

  describe "build_from_many/1" do
    test "When a file list is provided, builds the report" do
      filenames = ["report_test.csv", "report_test.csv"]

      response =
        filenames
        |> ReportsGenerator.build_from_many()

      expected_response =
        {:ok,
         %{
           "foods" => %{
             "açaí" => 2,
             "churrasco" => 4,
             "esfirra" => 6,
             "hambúrguer" => 4,
             "pastel" => 0,
             "pizza" => 4,
             "prato_feito" => 0,
             "sushi" => 0
           },
           "users" => %{
             "1" => 96,
             "10" => 72,
             "11" => 0,
             "12" => 0,
             "13" => 0,
             "14" => 0,
             "15" => 0,
             "16" => 0,
             "17" => 0,
             "18" => 0,
             "19" => 0,
             "2" => 90,
             "20" => 0,
             "21" => 0,
             "22" => 0,
             "23" => 0,
             "24" => 0,
             "25" => 0,
             "26" => 0,
             "27" => 0,
             "28" => 0,
             "29" => 0,
             "3" => 62,
             "30" => 0,
             "4" => 84,
             "5" => 98,
             "6" => 36,
             "7" => 54,
             "8" => 50,
             "9" => 48
           }
         }}

      assert response == expected_response
    end

    test "When a filelist is not provided, returns a error" do
      response = ReportsGenerator.build_from_many("report_test.csv")

      expected_response = {:error, "Please provide a list of strings"}

      assert response == expected_response
    end
  end

  describe "fetch_higher/2" do
    test "when the option is 'users', returns who spent the most" do
      filename = "report_test.csv"

      response =
        filename
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher("users")

      expected_response = {:ok, {"5", 49}}

      assert response == expected_response
    end

    test "when the option is 'foods', returns the most consumed food" do
      filename = "report_test.csv"

      response =
        filename
        |> ReportsGenerator.build()
        |> ReportsGenerator.fetch_higher("foods")

      expected_response = {:ok, {"esfirra", 3}}

      assert response == expected_response
    end
  end
end
