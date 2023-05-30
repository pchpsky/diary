[
  plugins: [Phoenix.LiveView.HTMLFormatter],
  import_deps: [:ecto, :ecto_sql, :phoenix, :phoenix_html, :phoenix_live_view],
  inputs: [
    "*.{heex,ex,exs}",
    "priv/*/seeds.exs",
    "{config,lib,test}/**/*.{heex,ex,exs}",
    "*.{ex,exs}",
    "priv/*/seeds.exs",
    "{config,lib,test}/**/*.{ex,exs}"
  ],
  subdirectories: ["priv/*/migrations"],
  line_length: 120
]
