defmodule Chucky.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(type, _args) do
    children = [
      # Starts a worker by calling: Chucky.Worker.start_link(arg)
      {Chucky.Server, []}
    ]

    case type do
      :normal ->
        Logger.info "Application start on #{node()}"
      {:takeover, old_node} ->
        Logger.info("#{node()} take over the #{old_node}")
      {:failover, old_node} ->
        Logger.info("#{old_node} is failling over to #{node()}")
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: {:global, Chucky.Supervisor}]
    Supervisor.start_link(children, opts)
  end
end
