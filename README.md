# LoggerLagerBackend

A `lager` (https://github.com/basho/lager) backend for Elixir's `Logger`
(http://elixir-lang.org/docs/master/logger/Logger.html).

That is, it routes messages generated with `Logger.<level>()` to `lager`. This
is useful if you have a mixed Erlang/Elixir project and have decided to
standardize on `lager` as a logging framework.

Known limitations:
* You're on your own to configure and start `lager`.
* Only `lager`'s default sink (`:lager_event`) is used.
* Performance is probably not ideal - all messages received are sent to `lager`
  regardless of the configured level and `lager`'s compile-time optimization
  does not happen. However, `Logger` will still do its own optimization
  upstream of this backend.
* Metadata is passed straight from `Logger` to `lager`, hoping that the keys
  match. It seems to be the case for the basics (`module`, `function`...) but
  may need looking into.

## Installation

Add `logger_lager_backend` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:logger_lager_backend, "~> 0.1.0"}]
end
```

## Configuration

Instruct `Logger` to use `logger_lager_backend`:

```elixir
config :logger,
  backends: [LoggerLagerBackend],
  level: :debug
```

This sends all messages of level `debug` or higher to `lager`. They will then
be subject to filtering and routing according to whichever `lager` config you
have in place.

## Troubleshooting

### `FORMAT ERROR`s in log

If you get `FORMAT ERROR` messages like this one:

```text
FORMAT ERROR: "~s" [[<<"GenServer :redis_sub_0_8 terminating">>,<<"\n** (stop) ">>|<<":redis_down">>]
```

You're probably hitting [basho/lager#326](https://github.com/basho/lager/issues/326). Upgrade
`lager` to `3.2.0` or more recent.

### `Elixir.Logger.Supervisor` error on startup

If you get the following message on startup:

```text
[error] Supervisor 'Elixir.Logger.Supervisor' had child 'Elixir.Logger.ErrorHandler' started with
  'Elixir.Logger.Watcher':watcher(error_logger, 'Elixir.Logger.ErrorHandler',
  {true,false,500}, link) at <0.422.0> exit with reason normal in context child_terminated
```

Make sure the `:lager` application is started before `:logger`, by putting
`:lager` first in your `applications` list in `mix.exs`:

```elixir
def application do
  [applications: [:lager, :logger, …],
   mod: {MyApp, []}]
end
```

## Related projects

* [lager_logger](https://github.com/PSPDFKit-labs/lager_logger) does the
  opposite of this backend: it sends `lager` messages to `Logger`.
* [exlager](https://github.com/khia/exlager) offers an Elixir frontend to
  `lager`, which can be an alternative to this backend if you control all the
  code that does logging. But if you are using e.g. `Ecto`, which writes to
  `Logger`, `exlager` will not help you.
