defmodule WebClientWeb.BlogView do
  use WebClientWeb, :view

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

  def pagination(assigns) do
    ~H"""
    <div class="pagination">
      <%= for p <- (1..@pagination[:pages]) do %>
        <%= link("#{p}",
          to: "/?page=#{p}&per_page=#{@pagination[:per_page]}",
          class: "page " <> (if @pagination[:page] == p, do: "active", else: "inactive") )
        %>
      <% end %>
    </div>
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
