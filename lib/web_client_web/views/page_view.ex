defmodule WebClientWeb.PageView do
  use WebClientWeb, :view

  def markdown(assigns) do
    {:ok, html, _} = Earmark.as_html(assigns.body)

    ~H"""
    <div class="markdown">
      <%= raw html %>
    </div>
    """
  end
end
