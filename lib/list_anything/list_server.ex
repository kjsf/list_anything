defmodule ListAnything.ListServer do
  @moduledoc """
    A GenServer that handles operations and keeps the list data for the application.
  """
  @name :list_server

  use GenServer
  alias ListAnything.ListData

  # Client Side

  @doc false
  def start_link(_args) do
    GenServer.start(__MODULE__, :ok, name: @name)
  end

  @doc """
    Creates a list with given `title`.
  """
  def create(title) do
    GenServer.call(@name, {:create, title})
  end

  @doc """
    Returns the contents of the list with the given `title`.
  """
  def get(title) do
    GenServer.call(@name, {:get, title})
  end

  @doc """
    Returns all available lists and their contents.
  """
  def get_all() do
    GenServer.call(@name, :get_all)
  end

  @doc """
    Creates `entry` to the given list `title`.
  """
  def add_entry(title, entry) do
    GenServer.call(@name, {:add_entry, title, entry})
  end

  @doc """
    Deletes `entry` from the given list `title`.
  """
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
    # May be useful references for someone in the future.
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
