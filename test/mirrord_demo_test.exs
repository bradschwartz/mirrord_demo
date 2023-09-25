defmodule MirrordDemoTest do
  use ExUnit.Case
  doctest MirrordDemo

  test "greets the world" do
    assert MirrordDemo.hello() == :world
  end
end
