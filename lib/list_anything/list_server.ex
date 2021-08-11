defmodule ListAnything.ListServer do
  @name :list_server
  use GenServer

  def start_link() do
    GenServer.start(__MODULE__, :ok, name: @name)
  end

  @impl true
  def init(:ok) do
    {:ok, []}
  end

  def get_list() do
    GenServer.call(@name, :get_list)
  end

  # Client Side
  def add_entry(entry) do
    GenServer.call(@name, {:add_entry, entry})
  end

  # Server Side

  @impl true
  def handle_call(:get_list, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:add_entry, entry}, _from, state) do
    new_state = [entry | state]

    {:reply, "#{entry} added to list", new_state}
  end
end
