# ListAnything

**Create lists about _ABSOLUTELY_ anything.**

*This app was created to practice elixir and OTP skills.*

## Usage

### Clone the repo and run this on the command line.
```bash
    iex -S mix
```
### Create a list
```elixir
    iex> ListAnything.ListServer.create("my list")
    "my list list created"
```

### Add an entry to a list
```elixir
    iex> ListAnything.ListServer.add_entry("my list", "my entry")
    "my entry added to the list my list"
```

### Remove an entry to a list
```elixir
    iex> ListAnything.ListServer.remove_entry("my list", "my entry")
    "my entry removed from the list my list"
```

### Retrieve all lists and their contents
```elixir
    iex> ListAnything.ListServer.get_all()
    %{
      "kez" => %ListAnything.ListData{entries: []},
      "my list" => %ListAnything.ListData{entries: []}
    }
```

### Retrieve contents of specific list
```elixir
    iex> ListAnything.ListServer.get("my list")
    ["another entry", "my entry"]
```

