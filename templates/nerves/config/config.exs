use Mix.Config<%= if @push do %>

# Adds a rootfs overlay for host SSH key.
config :nerves, :firmware,
  rootfs_overlay: "rootfs_overlay"<% else %>

# # Uncomment all or parts of the following to add files to the root
# # filesystem or modify the firmware archive.
# config :nerves, :firmware,
#   rootfs_overlay: "rootfs_overlay",
#   fwup_conf: "config/fwup.conf"<% end %><%= if @net do %>

# Configures the network.
config :nerves_network, :default,
  eth0: [
    ipv4_address_method: :static,
    ipv4_address: "10.0.0.1",
    ipv4_subnet_mask: "255.255.255.0",
    nameservers: ["8.8.8.8", "8.8.4.4"],
    domain: "example.com"
  ],
  wlan0: [
    ssid: System.get_env("NERVES_WLAN_SSID"),
    psk: System.get_env("NERVES_WLAN_PSK"),
    key_mgmt: :"WPA-PSK",
    ipv4_address_method: :dhcp
  ]<% end %><%= if @push do %>

# Configures the SSH key for firmware pushes.
config :nerves_firmware_ssh,
  authorized_keys: [
    "../priv/ssh/id_rsa.pub" |> Path.expand(__DIR__) |> File.read!()
  ]<% end %>

# Use shoehorn to init critical applications before starting ours.
config :shoehorn,
  init: [:nerves_runtime<%= if @net do %>, :nerves_network<% end %>],
  app: Mix.Project.config()[:app]

# # Import target specific config. This must remain at the bottom of this
# # file so it overrides the configuration defined above.
# import_config "#{Mix.Project.config[:target]}.exs"