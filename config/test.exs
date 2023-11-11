import Config

config :elixir_testing_tips, ElixirTestingTips.Repo,
  database: "./database/test.db",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warning
