defmodule Ozzy.Bot do
  use Slack

  def handle_connect(slack, state) do
    {:ok, state}
  end

  def handle_event(message = %{user: user, type: "message", text: text}, slack, state) do
    name = Slack.Lookups.lookup_user_name(user, slack)
    own_marker = "<@#{slack.me.id}>"
    if String.starts_with?(text, own_marker) do
        text
        |> String.replace(own_marker, "")
        |> String.strip
        |> Ozzy.Brain.dispatch(self(), name)

        send_message("#{name}, let me see what I can do about it!", message.channel, slack)
    end
    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    send_message(text, channel, slack)
    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
