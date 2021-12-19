defmodule WebClientWeb.BlogController do
  use WebClientWeb, :controller

  alias WebClient.Post

  use NimblePublisher,
    build: Post,
    from: "priv/posts/**/*.md",
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})
         |> Post.normalize_tags()
         |> Post.generate_previews()
         |> Post.find_images()

  @tags @posts
        |> Enum.flat_map(& &1.tags)
        |> Enum.map(&String.downcase/1)
        |> Enum.uniq()
        |> Enum.sort()

  def all_posts, do: @posts
  def all_tags, do: @tags

  # GET /
  def index(conn, _params) do
    render(conn, "index.html", posts: all_posts(), tags: all_tags())
  end

  # GET /posts/:id
  def read(conn, %{"id" => id}) do
    post =
      all_posts()
      |> Enum.find(fn p -> p.id == id end)

    render(conn, "read.html", post: post)
  end
end
