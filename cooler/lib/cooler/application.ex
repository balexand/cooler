defmodule Cooler.Application do
  use Application

  @gpio Application.get_env(:cooler, :gpio)

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(CoolerWeb.Endpoint, []),
      worker(@gpio, [ 4, :output, [name:  :pump_relay]], id: :pump_gpio),
      worker(@gpio, [17, :output, [name: :motor_relay]], id: :motor_gpio),
      worker(Cooler.PowerController, []),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cooler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CoolerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
