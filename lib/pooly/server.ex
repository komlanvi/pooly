defmodule Pooly.Server do
  @moduledoc false
  use GenServer

  @name __MODULE__

  defmodule State do
    defstruct supervisor: nil, size: nil, mfa: nil, worker_sup: nil, workers: nil
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

  def handle_info(:start_worker_supervisor, state = %{supervisor: supervisor, mfa: mfa, size: size}) do
    {:ok, worker_sup} = Supervisor.start_child(supervisor, supervisor_spec(mfa))
    workers = prepopulate(size, worker_sup)
    {:noreply, %{state | worker_sup: worker_sup, workers: workers}}
  end

  ###########
  # HELPERS #
  ###########
  defp supervisor_spec(mfa) do
    supervisor_opts = [restart: :temporary]
    supervisor({Pooly.WorkerSupervisor, [mfa], supervisor_opts})
  end

  defp prepopulate(size, worker_sup) do
    prepopulate(size, worker_sup, [])
  end
  defp prepopulate(size, worker_sup, workers) when size < 1 do
    workers
  end
  defp prepopulate(size, worker_sup, workers) when size > 0 do
    prepopulate(size-1, worker_sup, [new_worker(worker_sup) | workers])
  end

  defp new_worker(worker_sup) do
    {:ok, worker_pid} = Supervisor.start_child(worker_sup, [[]])
    worker_pid
  end
end
