defmodule Ozzy.BotScript do

  def load() do
    YamlElixir.read_from_file("config/default.yml")
  end
end
