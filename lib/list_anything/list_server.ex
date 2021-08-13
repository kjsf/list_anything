defmodule ListAnything.ListServer do
  @name :list_server

  use GenServer
  alias ListAnything.ListData

  # Client Side

  def start_link(_args) do
    GenServer.start(__MODULE__, :ok, name: @name)
  end

  def create(title) do
    GenServer.call(@name, {:create, title})
  end

  def get(title) do
    GenServer.call(@name, {:get, title})
  end

  def get_all() do
    GenServer.call(@name, :get_all)
  end

  def add_entry(title, entry) do
    GenServer.call(@name, {:add_entry, title, entry})
  end

  def remove_entry(title, entry) do
    GenServer.call(@name, {:remove_entry, title, entry})
  end

  # Server Side

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get, title}, _from, state) do
    # entries = get_in(state, [title, Access.key(:entries), Access.all()])

    %{^title => %{entries: entries}} = state

    {:reply, entries, state}
  end

  def handle_call({:create, title}, _from, state) do
    new_state = Map.put_new(state, title, %ListData{})

    {:reply, "#{title} list created", new_state}
  end

  def handle_call({:add_entry, title, entry}, _from, state) do
    new_state =
      update_in(state, [title, Access.key(:entries)], fn entries ->
        [entry | entries]
      end)

    {:reply, "#{entry} added to the list #{title}", new_state}
  end

  def handle_call({:remove_entry, title, entry}, _from, state) do
    new_state =
      update_in(state, [title, Access.key(:entries)], fn entries ->
        List.delete(entries, entry)
      end)

    {:reply, "#{entry} removed from the list #{title}", new_state}
  end
end

# alias ListAnything.ListServer

# ListServer.start_link([])

# ListServer.create("hello") |> IO.puts()
# ListServer.add_entry("hello", ["world", "kez"]) |> IO.inspect()
# ListServer.get("hello") |> IO.inspect()
