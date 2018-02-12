# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

# config :nerves, :firmware,
#   rootfs_overlay: "rootfs_overlay",
#   fwup_conf: "config/fwup.conf"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Import gitignored file containing hardcoded wifi config
import_config "wifi.exs"

config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcp,
  mdns_domain: "cooler.local",
  node_name: nil,
  node_host: :mdns_domain

config :cooler, CoolerWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 80],
  secret_key_base: "bqnE47+fCGCpuSNrLdVCk6IQL7jHhv5RIktAOb6xj43g1Gnq9NRyIVnitAIIFLtF",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: CoolerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
