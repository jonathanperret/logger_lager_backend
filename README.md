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

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add logger_lager_backend to your list of dependencies in `mix.exs`:

        def deps do
          [{:logger_lager_backend, "~> 0.0.1"}]
        end

  2. Ensure logger_lager_backend is started before your application:

        def application do
          [applications: [:logger_lager_backend]]
        end

## Configuration

```elixir
config :logger,
  backends: [LoggerLagerBackend],
  level: :debug
```

## Related projects

* [lager_logger](https://github.com/PSPDFKit-labs/lager_logger) does the
  opposite of this backend: it sends `lager` messages to `Logger`.
* [exlager](https://github.com/khia/exlager) offers an Elixir frontend to
  `lager`, which can be an alternative to this backend if you control all the
  code that does logging. But if you are using e.g. `Ecto`, which writes to
  `Logger`, `exlager` will not help you.
