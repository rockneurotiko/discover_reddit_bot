defmodule DiscoverRedditBot.Bot do
  @bot :discover_reddit_bot

  require Logger

  alias DiscoverRedditBot.{Parser, TextFormatter}

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")
  command("help", description: "Print the bot's help")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, "Here is your help:")
  end

  def handle({:text, text, _msg}, context) do
    subreddits_detected = Parser.get_subreddits(text)
    message = TextFormatter.format_subreddits(subreddits_detected)

    if subreddits_detected != [] do
      answer(context, message, parse_mode: "Markdown")
    end
  end

  def handle({:inline_query, %{query: text}}, context) do
    articles =
      text
      |> Parser.get_subreddits()
      |> TextFormatter.get_inline_articles()

    answer_inline_query(context, articles)
  end
end