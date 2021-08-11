defmodule ListAnything.ListServer do
  @name :list_server
  use GenServer
  alias ListAnything.ListData

  def start_link() do
    GenServer.start(__MODULE__, :ok, name: @name)
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  def create_list(title) do
    GenServer.call(@name, {:create_list, title})
  end

  def get_list_all() do
    GenServer.call(@name, :get_list_all)
  end

  # Client Side
  def add_entry(list_title, entry \\ []) do
    GenServer.call(@name, {:add_entry, list_title, entry})
  end

  def remove_entry(list_title, entry \\ []) do
    GenServer.call(@name, {:remove_entry, list_title, entry})
  end

  # Server Side

  @impl true
  def handle_call(:get_list_all, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:create_list, title}, _from, state) do
    new_state = Map.put_new(state, title, %ListData{})

    {:reply, "#{title} list created", new_state}
  end

  def handle_call({:add_entry, list_title, entry}, _from, state) do
    new_state =
      update_in(state, [list_title, Access.key(:entries)], fn entries ->
        [entry | entries]
      end)

    {:reply, "#{entry} added to list #{list_title}", new_state}
  end

  def handle_call({:remove_entry, list_title, entry}, _from, state) do
    new_state =
      update_in(state, [list_title, Access.key(:entries)], fn entries ->
        List.delete(entries, entry)
      end)

    {:reply, "#{entry} added to list #{list_title}", new_state}
  end
end
