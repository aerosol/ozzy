defmodule Ozzy.Brain do
  use GenServer

  @help_triggers ~w(help triggers)

  def start_link() do
    {:ok, _} = GenServer.start_link(__MODULE__, [], name: Brain)
  end

  def init([]) do
    script = Ozzy.BotScript.load()
    {:ok, script}
  end

  def dispatch(query, bot, user) do
    GenServer.cast(Brain, {:query, bot, user, query})
  end

  def handle_cast({:query, bot, user, query}, state) do
    case anything_to_say?(query, state) do
      {:reply, reply} ->
        send bot, {:message, "#{user}, #{reply}", "#test"}
      _ ->
        :ignore
    end
    {:noreply, state}
  end

  def anything_to_say?(help, %{"triggers" => triggers})
  when help in @help_triggers do
    trigger_list =
      triggers
      |> Enum.map(&(&1["on"]))
      |> Enum.join("\n")
    {:reply, "I am currently capable of the following: #{snippet(trigger_list)}"}
  end
  def anything_to_say?(query, %{"triggers" => triggers}) do
    if resp = known?(query, triggers) do
      {chdir, command} = resp
      {:done, status, stdout} = :erlsh.run(command, '/tmp/ozzy.log', chdir)
      {:reply, "Done. Status: #{qualify(status)}"}
    else
      {:reply, "I'm afriad I don't understand :thinking_face:"}
    end
  end

  defp qualify(0), do: "OK"
  defp qualify(code), do: "ERROR #{code}."

  defp known?(query, triggers) do
    found = Enum.find(triggers, &(String.starts_with?(query, &1["on"])))
    if found do
      command =
        found["shell"]
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_charlist/1)
      {found["chdir"] || "./", command}
    end
  end

  defp snippet(s), do: "\n```#{s}```"
end
