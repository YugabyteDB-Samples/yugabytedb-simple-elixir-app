# Simple Elixir App With Postgrex

The application uses the Postgrex driver to connect to the YugabyteDB cluster. The driver is defined as a dependency in the `mix.exs` file:

```elixir
defp deps do
    [
      {:postgrex, ">= 0.18.0"}
    ]
end
```

Run the sample by following these commands:

1. Add all the required dependencies:

    ```shell
    mix depts.get
    ```

2. Compile the app and start an iex session:

    ```shell
    iex -S mix
    ```

3. Run the app:

    ```shell
    SimpleApp.start
    ```
