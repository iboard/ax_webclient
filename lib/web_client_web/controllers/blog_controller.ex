defmodule WebClientWeb.BlogController do
  use WebClientWeb, :controller

  @env Mix.env() 

  if @env == :test do
    @posts_path "test/fixtures/posts/**/*.md"
  else
    @posts_path "priv/posts/**/*.md"
  end

  alias WebClient.Post

  use NimblePublisher,
    build: Post,
    from: @posts_path,
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
      |> filter_allowed_posts(conn)
      |> Enum.chunk_every(per_page)

    page = if page > Enum.count(pages), do: Enum.count(pages), else: page
    page = if page < 1, do: 1, else: page

    posts = Enum.at(pages, page - 1)

    pagination = [page: page, per_page: per_page, pages: Enum.count(pages)]

    render(conn, "index.html",
      posts: posts,
      pagination: pagination,
      tags: all_tags(),
      tag: nil
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

  #
  # GET /tags/:tag
  def tags(conn, %{"tag" => tag} = params) do
    page = (params["page"] || "1") |> String.to_integer()
    per_page = (params["per_page"] || "2") |> String.to_integer()

    pages =
      all_posts()
      |> Enum.filter(fn post ->
        String.downcase(tag) in Enum.map(post.tags, &String.downcase(&1))
      end)
      |> Enum.chunk_every(per_page)

    page = if page > Enum.count(pages), do: Enum.count(pages), else: page
    page = if page < 1, do: 1, else: page

    posts = Enum.at(pages, page - 1)

    pagination = [
      tag: tag,
      tags: all_tags(),
      page: page,
      per_page: per_page,
      pages: Enum.count(pages)
    ]

    render(conn, "index.html",
      posts: posts,
      pagination: pagination,
      tag: tag,
      tags: all_tags()
    )
  end

  defp filter_allowed_posts(posts, conn) do
    Enum.filter(posts, fn post ->
      WebClientWeb.SessionView.allow?(conn, :read, post)
    end)
  end
end
