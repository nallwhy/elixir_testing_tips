defmodule ElixirTestingTips.Repo do
  use Ecto.Repo, otp_app: :elixir_testing_tips, adapter: Ecto.Adapters.SQLite3
end
