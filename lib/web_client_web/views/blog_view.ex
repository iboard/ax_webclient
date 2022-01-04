defmodule WebClientWeb.BlogView do
  use WebClientWeb, :view

  def images_preview(assigns) do
    ~H"""
    <%= for image <- @post.images |> Enum.take(1) do %>
      <.image_preview image={ image } />
    <% end %>
    """
  end

  def image_preview(assigns) do
    # {"img",
    # [
    #   {"src", "https://e-matrix.at/assets/ematrix-large.png"},
    #   {"width", "196px"},
    #   {"style", "margin: 1rem; margin-top: 2rem;"}
    # ], []}
    img =
      case assigns.image do
        {"img", attrs, _} -> build_image_tag(attrs)
        e -> "#{inspect(e)}"
      end

    ~H"""
    <%= img %>
    """
  end

  def tag_links(assigns) do
    ~H"""
    <%= for tag <- @tags do %>
      <%= if tag == @tag do %>
        <a class="tag-link active" href={ "/tags/#{tag}?page=#{@pagination[:page]}&per_page=#{ @pagination[:per_page] }" }><%= tag %></a>
      <% else %>
        <a class="tag-link inactive" href={ "/tags/#{tag}?page=#{@pagination[:page]}&per_page=#{ @pagination[:per_page] }" }><%= tag %></a>
      <% end %>
    <% end %>
    """
  end

  def post_tags(assigns) do
    ~H"""
    <%= for tag <- @post.tags |> Enum.map(&String.downcase/1) |> Enum.uniq() |> Enum.sort do %>
      <%= if tag == @tag do %>
        <a class="font-semibold" href={ "/tags/#{tag}" }><%= tag %></a>
      <% else %>
        <a class="text-gray-400" href={ "/tags/#{tag}" }><%= tag %></a>
      <% end %>
    <% end %>
    """
  end

  def pagination(assigns) do
    ~H"""
    <%= if @pagination[:pages] > 1 do %>
      <% prefix = if @tag,  do: "/tags/#{@tag}", else: "/" %>
      <div class="pagination">
        <%= for p <- (1..@pagination[:pages]) do %>
          <%= link("#{p}",
            to: "#{prefix}?page=#{p}&per_page=#{@pagination[:per_page]}",
            class: "page " <> (if @pagination[:page] == p, do: "active", else: "inactive") )
          %>
        <% end %>
      </div>
    <% end %>
    """
  end

  def post_preview(assigns) do
    post_id = "post-" <> assigns[:post].id

    ~H"""
    <div class="post mb-10" id={ post_id }>
      <div class="my-1 text-2xl text-gray-600">
        <%= link(@post.title, to: "/posts/#{@post.id}" ) %>
        <.draft_label post={ @post } />
        <.private_label post={ @post } />
      </div>
      <div class="text-xs inline"><.post_tags post={ @post } tag={ @tag } /></div>
      <div class="inline mt-0 text-sm text-gray-400"><%= @post.author %>, <%= @post.date %></div>
      <div class="markdown w-prose">
        <.images_preview post={ @post } />
        <.iframe_preview post={ @post } />
        <%= raw @post.preview %>
      </div>
      <div class="text-gray-400 italic"><%= link gettext("read more..."), to: "/posts/#{@post.id}" %></div>
    </div>
    """
  end

  def iframe_preview(assigns) do
    ~H"""
    <%= for iframe <- @post.iframes |> Enum.take(1) do %>
      <div class="my-4 max-w-full"><%= raw Floki.raw_html(iframe) %></div>
    <% end %>
    """
  end

  def private_label(assigns) do
    ~H"""
    <%= for p <- @post.private || [] do %>
      <div class="inline p-1 text-sm rounded bg-red-300"><%= p %></div>
    <% end %>
    """
  end

  def draft_label(assigns) do
    ~H"""
    <%= if @post.draft do %>
      <div class="inline p-1 text-sm rounded bg-yellow-300">draft</div>
    <% end %>
    """
  end

  defp build_image_tag(attrs) do
    inspect(attrs, pretty: true)

    Enum.reduce_while(attrs, "", fn
      {"src", src}, _acc ->
        {:halt,
         raw(~s"""
         <img src="#{src}" align="left" class="drop-shadow max-h-32 pr-3 py-2 pb-0 pt-2" />
         """)}

      _, acc ->
        {:cont, acc}
    end)
  end
end
