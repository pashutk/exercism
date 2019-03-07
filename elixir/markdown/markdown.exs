defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    markdown
    |> String.split("\n")
    |> Enum.map_join("", &process_line/1)
    |> wrap_list()
  end

  defp process_line("#" <> _tail = line), do: process_header(line)
  defp process_line("* " <> tail), do: process_line(tail, "li")

  defp process_line(line, tag \\ "p") do
    line
    |> String.split()
    |> Enum.map_join(" ", &replace_md/1)
    |> enclose_with_tag(tag)
  end

  defp process_header(line) do
    [head_md | tail] = String.split(line)
    level = String.length(head_md)

    Enum.join(tail, " ")
    |> enclose_with_tag("h#{level}")
  end

  defp enclose_with_tag(content, tag), do: "<#{tag}>#{content}</#{tag}>"

  defp replace_md(md) do
    md
    |> String.replace(~r/^__/, "<strong>")
    |> String.replace(~r/__$/, "</strong>")
    |> String.replace(~r/^_/, "<em>")
    |> String.replace(~r/_$/, "</em>")
  end

  defp wrap_list(text) do
    text
    |> String.replace("<li>", "<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end
end
