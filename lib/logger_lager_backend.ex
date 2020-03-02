defmodule LoggerLagerBackend do
  @behaviour :gen_event

  @moduledoc """
  A `lager` backend for `Logger`.
  """

  @sink :lager_event
  @truncation_size 4096

  def init(__MODULE__) do
    sinks = [@sink | extra_sinks()]

    {:ok, %{sinks: sinks}}
  end

  def handle_call({:configure, _opts}, state) do
    sinks = [@sink | extra_sinks()]

    {:ok, :ok, %{state | sinks: sinks}}
  end

  defp to_lager_level(:warn), do: :warning
  defp to_lager_level(level), do: level

  def handle_event({level, _groupleader, {Logger, message, _timestamp, metadata}}, state) do
    for sink <- state.sinks do
      :lager.dispatch_log(sink, to_lager_level(level), metadata, '~ts', [message], @truncation_size, :safe)
    end

    {:ok, state}
  end

  def handle_event(:flush, state) do
    # No real lager equivalent
    {:ok, state}
  end

  def code_change(_vsn, nil, _extra) do
    sinks = [@sink | extra_sinks()]

    {:ok, %{sinks: sinks}}
  end

  defp extra_sinks do
    for {name, _} <- Application.get_env(:lager, :extra_sinks, []), do: name
  end
end
