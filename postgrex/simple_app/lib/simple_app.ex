defmodule SimpleApp do
  @db_config [
    hostname: "127.0.0.1",
    port: 5433,
    database: "yugabyte",
    username: "yugabyte",
    password: "yugabyte",
    ssl: false,
    ssl_opts: [cacertfile: ~c"/home/certs/my_cert.pem"]
  ]

  def start do
    db_config = @db_config
    {:ok, pid} = Postgrex.start_link(db_config)

    IO.puts(">>>> Successfully connected to YugabyteDB! PID: #{inspect(pid)}")
    
    # Create a sample database
    create_database(pid)

    # Select accounts
    select_accounts(pid)

    # Transfer money between accounts
    transfer_money(pid, 800)

    # Select accounts one more time
    select_accounts(pid)

    # Close the connection.
    # There is no public API yet: https://github.com/richardkmichael/postgrex/issues/1
    GenServer.stop(pid)
  end

  def create_database(pid) do
    Postgrex.query!(pid, "DROP TABLE IF EXISTS DemoAccount", [])

    Postgrex.query!(pid, """
      CREATE TABLE DemoAccount (
          id int PRIMARY KEY,
          name varchar,
          age int,
          country varchar,
          balance int)
      """,[])

    Postgrex.query!(pid, """
      INSERT INTO DemoAccount VALUES
          (1, 'Jessica', 28, 'USA', 10000),
          (2, 'John', 28, 'Canada', 9000)
      """,[])

    IO.puts(">>>> Successfully created table DemoAccount.")
  end

  def select_accounts(pid) do
    IO.puts(">>>> Selecting accounts:")

    result = Postgrex.query!(pid,
      "SELECT name, age, country, balance FROM DemoAccount", [])

    Enum.each(result.rows, fn row ->
      IO.inspect(row)
    end)
  end

  def transfer_money(pid, amount) do
    Postgrex.transaction(pid, fn(conn) ->
      # Deduct amount from Jessica's account
      Postgrex.query!(conn,
        "UPDATE DemoAccount SET balance = balance - $1 WHERE name = 'Jessica'", [amount])

      # Add amount to John's account
      Postgrex.query!(conn,
        "UPDATE DemoAccount SET balance = balance + $1 WHERE name = 'John'", [amount])
    end)

    IO.puts(">>>> Transferred #{amount} between accounts.")
  end
end
