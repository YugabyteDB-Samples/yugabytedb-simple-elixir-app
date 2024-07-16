# Simple Elixir App With Postgrex

The application uses the Postgrex driver to connect to the YugabyteDB cluster. The driver is defined as a dependency in the `mix.exs` file:

```elixir
defp deps do
    [
      {:postgrex, ">= 0.18.0"}
    ]
end
```

Run the following command to pull and add the dependency to the project:

```shell
* mix depts.get
```
