defmodule WebClientWeb.PageControllerTest do
  use WebClientWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "The Craftsman&#39;s Blog"
  end
end
