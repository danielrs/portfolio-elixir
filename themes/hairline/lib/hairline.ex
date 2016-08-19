defmodule Portfolio.Themes.Hairline do
  unless Application.get_env(:portfolio, :static_path) do
    raise ":static_path is not configured, were is the theme going to put the static files?"
  end

  brunch_config = EEx.eval_file "brunch-config.js.eex", [static_path: Application.get_env(:portfolio, :static_path)]

  {:ok, brunch_file} = File.open "brunch-config.js", [:write]
  IO.binwrite brunch_file, brunch_config
  File.close brunch_file
end
