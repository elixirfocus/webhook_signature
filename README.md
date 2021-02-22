# WebhookSignature

A sample Phoenix app to help demonstrate how to validate the signature of a webhook payload in Elixir.

Blog post: <https://phoenixbyexample.com>

## Usage Demo

```bash
$ curl --verbose \
       -H "Content-Type: application/json" \
       -H "X-Hub-Signature: sha256=g/asiiZ9oDukO5qHtbZl+o4wO9ST3GyQ1E4HoZv3y4w=" \
       -d '{"hello":"world"}' \
       http://127.0.0.1:4000/github/webhook
```

Output showing success, `HTTP/1.1 200 OK`:

```
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to 127.0.0.1 (127.0.0.1) port 4000 (#0)
> POST /github/webhook HTTP/1.1
> Host: 127.0.0.1:4000
> User-Agent: curl/7.64.1
> Accept: */*
> Content-Type: application/json
> X-Hub-Signature: sha256=g/asiiZ9oDukO5qHtbZl+o4wO9ST3GyQ1E4HoZv3y4w=
> Content-Length: 17
> 
* upload completely sent off: 17 out of 17 bytes
< HTTP/1.1 200 OK
< cache-control: max-age=0, private, must-revalidate
< content-length: 4
< content-type: application/json; charset=utf-8
< date: Mon, 22 Feb 2021 20:11:53 GMT
< server: Cowboy
< x-request-id: FmYq7ROzBOzPgWkAABIB
< 
* Connection #0 to host 127.0.0.1 left intact
null* Closing connection 0
```

## Standard Phoenix Things

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
