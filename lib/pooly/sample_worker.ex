defmodule Pooly.SampleWorker do
  @moduledoc false
  use GenServer

  #######
  # API #
  #######
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def stop(pid) do
    GenServer.call pid, :stop
  end

  #############
  # CALLBACKS #
  #############
  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end
end
