defmodule ElixirTestingTipsTest do
  use ExUnit.Case
  doctest ElixirTestingTips

  test "greets the world" do
    assert ElixirTestingTips.hello() == :world
  end
end
