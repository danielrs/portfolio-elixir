defmodule Portfolio.Themes.Hairline do
  unless Application.get_env(:portfolio, :static_path) do
    raise ":static_path is not configured, were is the theme going to put the static files?"
  end

  brunch_config = EEx.eval_file "brunch-config.js.eex", [static_path: Application.get_env(:portfolio, :static_path)]
  File.write! "brunch-config.js", brunch_config, [:write]
end
