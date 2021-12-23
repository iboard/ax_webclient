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
  def index(conn, %{"page" => page, "per_page" => per_page}) do
    page = String.to_integer(page)
    per_page = String.to_integer(per_page)

    pages =
      all_posts()
      |> Enum.chunk_every(per_page)

    page = if page > Enum.count(pages), do: Enum.count(pages), else: page
    page = if page < 1, do: 1, else: page

    posts = Enum.at(pages, page - 1)

    pagination = [page: page, per_page: per_page, pages: Enum.count(pages)]

    render(conn, "index.html",
      posts: posts,
      pagination: pagination,
      tags: all_tags()
    )
  end

  def index(conn, _params) do
    conn |> redirect(to: "/?page=1&per_page=2")
  end

  # GET /posts/:id
  def read(conn, %{"id" => id}) do
    post =
      all_posts()
      |> Enum.find(fn p -> p.id == id end)

    render(conn, "read.html", post: post)
  end
end
