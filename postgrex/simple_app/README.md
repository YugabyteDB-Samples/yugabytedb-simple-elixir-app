# Simple Elixir App With Postgrex

The application uses the Postgrex driver to connect to the YugabyteDB cluster. The driver is defined as a dependency in the `mix.exs` file:

```elixir
defp deps do
    [
      {:postgrex, ">= 0.18.0"}
    ]
end
```

## Starting the App

First, open the `lib\simple_app.ex` and provide the database connectivity settings:

* `hostname` - the host name of your database cluster.
* `port` - the port number (the default is `5433`).
* `database` - the name of the database to connect to (the default is `yugabyte`).
* `username` and `password` - the username and password for your database cluster.
* `ssl: [cacertfile:...]`- the full path to your YugabyteDB Aeon or another secure cluster CA certificate (for example, `/Users/dmagda/certificates/root.crt`)

Next, run the app by following these commands:

1. Navigate to the project's root folder:

    ```shell
    cd postgrex/simple_app
    ```

2. Add all the required dependencies:

    ```shell
    mix deps.get
    ```

3. Compile the app and start an iex session:

    ```shell
    iex -S mix
    ```

4. Run the app:

    ```shell
    SimpleApp.start
    ```

Lastly, verify that the ouput is as follows:

```output
>>>> Successfully connected to YugabyteDB! PID: #PID<0.221.0>
>>>> Successfully created table DemoAccount.
>>>> Selecting accounts:
["Jessica", 28, "USA", 10000]
["John", 28, "Canada", 9000]
>>>> Transferred 800 between accounts.
>>>> Selecting accounts:
["Jessica", 28, "USA", 9200]
["John", 28, "Canada", 9800]
:ok
```
