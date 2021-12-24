defmodule WebClientWeb.PageControllerTest do
  use WebClientWeb.ConnCase

  test "GET / redirects to /?page=1", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 302) =~ "?page=1&amp;per_page="
  end
end
