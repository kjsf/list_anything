defmodule ListAnything.ListServerTest do
  use ExUnit.Case
  alias ListAnything.ListServer

  setup do
    pid = start_supervised!(ListServer)
    %{pid: pid}
  end

  test "test create function" do
    assert ListServer.create("the test") == "the test list created"
  end

  test "test get function" do
    ListServer.create("my list")

    assert ListServer.get("my list") == []

    ListServer.add_entry("my list", "my entry")
    ListServer.add_entry("my list", "another entry")

    assert ListServer.get("my list") == ["another entry", "my entry"]
  end

  test "test add entry function" do
    assert ListServer.get_all() == %{}

    ListServer.create("my list")

    assert ListServer.add_entry("my list", "my entry") ==
             "my entry added to the list my list"

    assert ListServer.get_all() ==
             %{"my list" => %ListAnything.ListData{entries: ["my entry"]}}
  end

  test "test remove entry function" do
    ListServer.create("my list")

    ListServer.add_entry("my list", "my entry")
    ListServer.add_entry("my list", "another entry")
    ListServer.add_entry("my list", "yet another entry")

    assert ListServer.get_all() ==
             %{
               "my list" => %ListAnything.ListData{
                 entries: ["yet another entry", "another entry", "my entry"]
               }
             }

    ListServer.remove_entry("my list", "yet another entry")

    assert ListServer.get_all() ==
             %{"my list" => %ListAnything.ListData{entries: ["another entry", "my entry"]}}
  end
end
