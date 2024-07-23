# Simple Elixir App With Phoenix

This sample shows how to create a simple Phoenix app using YugabyteDB as a database.
As long as YugabyteDB is built on PostgreSQL, the app uses the Etco implemetation of Postgres.

## Configure the App

First, go to the `config/dev.exs` and update `config :simple_app, SimpleApp.Repo` with your database connectivity settings:

* `hostname` - the host name of your database cluster.
* `port` - the port number (the default is `5433`).
* `database` - the name of the database to connect to (the default is `yugabyte`).
* `username` and `password` - the username and password for your database cluster.
* `ssl_opt: [cacertfile:...]`- the full path to your YugabyteDB Aeon or another secure cluster CA certificate (for example, `/Users/dmagda/certificates/root.crt`)

Next, configure the project and run the app:

* Make sure you're in the root directory of the project:
    ```shell
    cd simple_app
    ```
* Install the dependencies:
    ```shell
    mix deps.get
    ```
* Create the database:
    ```shell
    mix ecto.create
    ```
* Apply the database migrations:
    ```shell
    mix ecto.migrate
    ```
    
## Run and Test the App

The application implements the API pipeline only. See the `router.ex` for details:
```elixir
  scope "/api", SimpleAppWeb do
    pipe_through :api

    resources "/accounts", AccountController,
      only: [:index, :show, :create, :delete]

    put "/accounts/transfer", AccountController, :transfer
  end
```

You would need to use a command-line tool to send HTTP requests to the supported API endpoints.

First, start the app:
```shell
mix phx.server
```

Next, add two accounts to the database:

1. Check that there are no accounts yet:
    ```shell
    http GET http://localhost:4000/api/accounts
    ```
    The result should be empty:
    ```output
    {
        "accounts": []
    }
    ```
2. Add two accounts:
    ```shell
    http POST http://localhost:4000/api/accounts name="John Doe" balance=1000
    http POST http://localhost:4000/api/accounts name="Marry Smith" balance=1000
    ```
3. Double-check the accounts were created:
    ```shell
    http GET http://localhost:4000/api/accounts
    ```
    ```output
    {
        "accounts": [
            {
                "balance": "1000",
                "id": 2,
                "name": "Marry Smith"
            },
            {
                "balance": "1000",
                "id": 1,
                "name": "John Doe"
            }
        ]
    }
    ```

The application also implements the `transfer` action that lets you transfer money from one account to another transactionally. 

1. Run the following command to transfer money from John to Marry:
    ```shell
    http PUT http://localhost:4000/api/accounts/transfer from=1 to=2 amount=500
    ```

2. Check the accounts' balances:
    ```shell
    http GET http://localhost:4000/api/accounts
    ```
    ```output
    {
        "accounts": [
            {
                "balance": "1500",
                "id": 2,
                "name": "Marry Smith"
            },
            {
                "balance": "500",
                "id": 1,
                "name": "John Doe"
            }
        ]
    }
    ```