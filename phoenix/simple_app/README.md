# SimpleApp

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Test

Get all accounts:
```shell
http GET http://localhost:4000/api/accounts
```

Add new account:
```shell
http POST http://localhost:4000/api/accounts name="John Doe" balance=1000
```

Delete account:
```shell
http DELETE http://localhost:4000/api/accounts/801
```

Transfer money between accounts:
```shell
http PUT http://localhost:4000/api/accounts/transfer from=1001 to=1002 amount=500
```