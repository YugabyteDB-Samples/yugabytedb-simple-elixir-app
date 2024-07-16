defmodule SimpleAppTest do
  use ExUnit.Case
  doctest SimpleApp

  test "test the app" do
    assert SimpleApp.start()
  end
end
