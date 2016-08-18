defmodule Portfolio.UtilsTest do
  use ExUnit.Case
  use Timex

  alias Portfolio.Utils

  @string "my cute(?) test string"
  @string_integer 2014

  @date Ecto.Date.cast!("1992-10-15")

  test "codify correctly converts string" do
    assert Utils.codify @string == @string_integer
  end

  test "format_date works with default formatter" do
    assert Utils.format_date(@date, "{Mshort} {0D}, {YYYY}") == "Oct 15, 1992"
  end

  test "format_date workds with strftime formatter" do
    assert Utils.format_date(@date, "%b %d, %Y", :strftime) == "Oct 15, 1992"
  end

  test "format_date works with relative formatter" do
    assert Utils.format_date(@date, "{relative}", :relative) =~ ~r/\d+ years ago/
  end

  test "format_date raises exception on wrong ecto date" do
    assert catch_error(Utils.format_date("1992-10-15", "{YYYY}"))
  end

  test "format_date raises exception on wrong format_string" do
    assert catch_error(Utils.format_date(@date, "{YY"))
  end

  test "format_date raises exception on wrong formatter" do
    assert catch_error(Utils.format_date(@date, "{YYYY}", :relteve))
  end
end
