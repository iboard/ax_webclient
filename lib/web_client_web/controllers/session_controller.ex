defmodule WebClientWeb.SessionController do
  use WebClientWeb, :controller

  alias WebClient.Session

  @default_request %{username: "", password: ""}

  def new(conn, _params) do
    render(conn, "new.html", request: @default_request)
  end

  def create(conn, %{"request" => params}) do
    if cu = Session.login(params["username"], params["password"]) do
      to = get_session(conn, :return_to) || "/"

      conn
      |> put_flash(:info, gettext("You're logged in"))
      |> put_session(:current_user, cu)
      |> redirect(to: to)
    else
      conn
      |> put_flash(:error, gettext("Wrong credentials. Try again"))
      |> put_session(:current_user, nil)
      |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> put_session(:current_user, nil)
    |> redirect(to: "/")
  end
end
