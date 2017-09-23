defmodule Portfolio.LanguageColorTest do
  use ExUnit.Case
  alias Portfolio.LanguageColor

  test "Gets valid colors from linguist" do
    assert LanguageColor.get("C++") == "#f34b7d"
    assert LanguageColor.get("Kotlin") == "#F18E33"
    assert LanguageColor.get("Haskell") == "#5e5086"
    assert LanguageColor.get("java") == "#b07219"
    assert LanguageColor.get("Rust") == "#dea584"
  end

  test "Gets invalid colors from fallback" do
    assert LanguageColor.get("CPLUSPLUS") == "#7E57C2"
  end
end
