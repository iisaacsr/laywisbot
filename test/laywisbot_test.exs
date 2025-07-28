defmodule LaywisBotTest do
  use ExUnit.Case
  doctest Laywisbot

  test "greets the world" do
    assert LaywisBot.hello() == :world
  end
end
