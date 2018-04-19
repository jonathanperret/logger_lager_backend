defmodule LoggerLagerBackend do
  @behaviour :gen_event

  @moduledoc """
  A `lager` backend for `Logger`.
  """

  @sink :lager_event
  @truncation_size 4096

  def init(__MODULE__) do
    {:ok, nil}
  end

  def handle_call({:configure, _opts}, state) do
    {:ok, :ok, state}
  end

  defp to_lager_level(:warn), do: :warning
  defp to_lager_level(level), do: level

  def handle_event({level, _groupleader, {Logger, message, _timestamp, metadata}}, state) do
    :lager.dispatch_log(@sink, to_lager_level(level), metadata, '~ts', [message], @truncation_size, :safe)
    {:ok, state}
  end

  # gen_event boilerplate

  def handle_info(_msg, state) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

  def code_change(_old, state, _extra) do
    {:ok, state}
  end
end
