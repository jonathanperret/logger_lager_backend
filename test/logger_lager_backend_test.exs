defmodule LoggerLagerBackendTest do
  use ExUnit.Case
  require Logger

  test "logging a simple message" do
    Logger.info "hello"
  end

  test "Logging iodata" do
    # see https://github.com/basho/lager/issues/326
    Logger.info [["hello", 9, "world" | [9 | "you"]]]
  end

  test "Logging UTF-8" do
    Logger.info "12µs"
    Logger.info '12µs'
    Logger.info fn -> "13µs" end
  end
end
