use Mix.Config

config :logger,
  backends: [LoggerLagerBackend],
  handle_otp_reports: false,
  level: :debug

config :lager,
  handlers: [ lager_console_backend: :debug ],
  colored: true
