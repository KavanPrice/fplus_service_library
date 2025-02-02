defmodule FplusServiceLibraryTest do
  use ExUnit.Case
  doctest FplusServiceLibrary

  test "greets the world" do
    assert FplusServiceLibrary.hello() == :world
  end
end
