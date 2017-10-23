defmodule Pooly.Server do
  @moduledoc false
  use GenServer

  @name __MODULE__

  defmodule State do
    defstruct sup: nil, size: nil, mfa: nil
  end

  #######
  # API #
  #######
  def start_link(sup, pool_config) do
    GenServer.start_link(__MODULE__, [sup, pool_config], name: @name)
  end

  #############
  # CALLBACKS #
  #############
  def init([sup, pool_config]) when is_pid(sup) do
    init(pool_config, %State{supervisor: sup})
  end
  def init([{:mfa, mfa = {_, _, _}} | rest], state) do
    init(rest, %{state | mfa: mfa})
  end
  def init([{:size, size} | rest], state) do
    init(rest, %{state | size: size})
  end
  def init([_ | rest], state) do
    init(rest, state)
  end
  def init([], state) do
    send self, :start_worker_supervisor
    {:ok, state}
  end

  def handle_info(:start_worker_supervisor, state) do

  end
end
