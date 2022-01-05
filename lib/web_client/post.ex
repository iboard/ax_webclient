defmodule WebClient.Post do
  require Logger
  defstruct ~w/id date author title body description tags draft images iframes private/a

  def build(filename, attrs, body) do
    attrs = cast(attrs)
    {id, date} = extract_id_and_date(filename)

    struct!(
      __MODULE__,
      [
        id: id,
        images: [],
        date: date,
        private: nil,
        body: remote_images("https://www.iboard.cc", body)
      ] ++ (attrs |> cast() |> Map.to_list())
    )
  end

  def normalize_tags(posts) do
    Enum.map(posts, fn post ->
      %{post | tags: Enum.map(post.tags, &String.downcase/1) |> Enum.uniq()}
    end)
  end

  def find_images(posts) do
    find_image(posts)
  end

  def generate_previews(post) do
    generate_preview(post)
  end

  ######################################################################

  defp cast(attrs) do
    Map.delete(attrs, :date)
  end

  defp extract_id_and_date(filename) do
    [year, month_day_id] = extract_date_and_id(filename)
    [month, day, id] = parse_date(month_day_id)
    {id, Date.from_iso8601!("#{year}-#{month}-#{day}")}
  end

  defp extract_date_and_id(filename) do
    filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
  end

  defp remote_images(prefix, body) do
    body
    |> String.replace("\"/assets/", "\"" <> prefix <> "/assets/")
  end

  defp parse_date(month_day_id) do
    String.split(month_day_id, "-", parts: 3)
  end

  ######################################################################

  defp find_image([]), do: []

  defp find_image([next | rest]) do
    [find_image(next) | find_image(rest)]
  end

  defp find_image(%__MODULE__{} = post) do
    images =
      case Floki.parse_document(post.body) do
        {:ok, parsed} ->
          Floki.find(parsed, "img")

        {:error, doc} ->
          IO.inspect(doc, label: "Can't parse html document")
          []
      end

    iframes =
      case Floki.parse_document(post.body) do
        {:ok, parsed} ->
          Floki.find(parsed, "iframe")

        {:error, doc} ->
          IO.inspect(doc, label: "Can't parse html document")
          []
      end

    %{post | images: images, iframes: iframes}
  end

  ######################################################################

  defp generate_preview([]), do: []

  defp generate_preview([next | rest]) do
    [generate_preview_for(next) | generate_preview(rest)]
  end

  defp generate_preview_for(post) do
    Map.put(post, :preview, sanitize_preview(post.body))
  end

  defp extract_first_words(parsed) do
    [first | rest] = parsed
    [Floki.text(first), Floki.text(rest)]
  end

  defp sanitize_preview(html) do
    preview =
      case Floki.parse_document(html) do
        {:ok, parsed} ->
          [first_words | rest] = extract_first_words(parsed)

          txt =
            Floki.text(rest)
            |> String.slice(0..255)

          "<span class=\"preview-first-text\">#{first_words}</span>" <>
            " " <> txt

        {:error, doc} ->
          doc
          |> IO.inspect(label: "Can't parse html document")
      end

    preview <> "...."
  end
end
