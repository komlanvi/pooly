defmodule Pooly.WorkerSupervisor do
  @moduledoc false
  use Supervisor

  #######
  # API #
  #######
  def start_link(mfa = {_, _, _}) do
    Supervisor.start_link(__MODULE__, mfa, [])
  end

  #############
  # CALLBACKS #
  #############
  def init({module, function, args}) do
    worker_opts = [restart: :permanent, function: function]
    children = [worker(module, args, worker_opts)]
    sup_opts = [strategy: :simple_one_for_one, max_restart: 5, max_seconds: 5]
    supervise(children, sup_opts)
  end
end
