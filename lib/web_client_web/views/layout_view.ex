defmodule WebClientWeb.LayoutView do
  use WebClientWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def html_head(assigns) do
    ~H"""
    <head>
      <meta charset="utf-8"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
      <.link_highlight_js />
      <%= csrf_meta_tag() %>
      <%= live_title_tag assigns[:page_title] || "WebClient", suffix: " · Altex" %>
      <link phx-track-static rel="stylesheet" href={Routes.static_path(@conn, "/assets/app.css")}/>
      <script defer phx-track-static
              type="text/javascript"
              src={ Routes.static_path(@conn, "/assets/app.js") }>
      </script>
    </head>
    """
  end

  def header(assigns) do
    ~H"""
    <header>
      <div><a href="/"><img class="logo" src={ Routes.static_path(WebClientWeb.Endpoint, "/images/logo.png") } /></a></div>
      <div class="flex-1">
        <div class="inline"><%= link gettext("Altex"), to: "/pages" %></div>
        <div class="inline ml-4"><%= link gettext("T.C.B."), to: "/" %></div>
      </div>
      <div class="item-stretch"></div>
      <div class="flex-end">
        <div class="inline min-w-20 pr-10 text-gray-400">
          <%= gettext "Node: " %><%= System.get_env("ALTEX_INSTANCE") %>
        </div>
        <%= if Plug.Conn.get_session(@conn, :current_user) do %>
          <%= link gettext("Sign out"), to: "/sign_out" %>
        <% else %>
          <%= link gettext("Sign in"), to: "/sign_in" %>
        <% end %>
      </div>
    </header>
    """
  end

  def footer(assigns) do
    ~H"""
    <footer>
      <section class="w-full p-10 flex w-full">
        <nav class="flex-1">
          &copy; 2021 by
          <a href="https://e-matrix.at" target="_blank">e-Matrix Innovations GmbH</a>
        </nav>
        <nav class="flex-1">
          <%= Node.self() |> inspect %> | <%= Node.list() |> inspect %>
        </nav>
        <nav class="flex-end">
        <ul>
          <li><a href="https://hexdocs.pm/phoenix/overview.html">Get Started</a></li>
          <%= if function_exported?(Routes, :live_dashboard_path, 2) do %>
            <li><%= link "LiveDashboard", to: Routes.live_dashboard_path(@conn, :home) %></li>
          <% end %>
        </ul>
        </nav>
      </section>
    </footer>
    """
  end

  def link_highlight_js(assigns) do
    ~H"""
      <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.3.1/styles/default.min.css"
      />
      <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.3.1/highlight.min.js">
      </script>
    """
  end
end
