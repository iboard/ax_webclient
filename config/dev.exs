import Config

config :web_client, WebClientWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: (System.get_env("PORT") || "4000") |> String.to_integer()],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "svwR3dmghhl4nlzJJYdt41yMSkgicmHIVHi32WyvJcBjdXrqWFoD8ww8n8AkIEZR",
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    npx: [
      "tailwindcss",
      "--input=css/app.css",
      "--output=../priv/static/assets/app.css",
      "--postcss",
      "--watch",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :web_client, WebClientWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"priv/posts/*/.*(md)$",
      ~r"lib/web_client_web/(live|views)/.*(ex)$",
      ~r"lib/web_client_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
