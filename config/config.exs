import Config

config :elixir_testing_tips, ecto_repos: [ElixirTestingTips.Repo]

import_config "#{config_env()}.exs"
