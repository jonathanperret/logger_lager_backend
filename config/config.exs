use Mix.Config

config :logger,
  backends: [LoggerLagerBackend],
  level: :debug

config :lager,
  handlers: [ lager_console_backend: :debug ],
  colored: true
