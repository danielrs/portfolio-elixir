defmodule Portfolio.Repo do
  use Ecto.Repo, otp_app: :portfolio
  use Scrivener, page_size: 10
end
