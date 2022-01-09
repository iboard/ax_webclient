defmodule WebClientWeb.BlogControllerTest do
  use WebClientWeb.ConnCase
  alias WebClient.Session

  test "GET / redirects to /?page=1", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 302) =~ "?page=1&amp;per_page="
  end

  test "pagination shows two pages", %{conn: conn} do
    conn = get(conn, "/?page=1&per_page=2")

    assert html_response(conn, 200) =~ "Post One"
    assert html_response(conn, 200) =~ "Post Two"
    refute html_response(conn, 200) =~ "Post Three"
  end

  test "pagination shows last post on page 2", %{conn: conn} do
    conn = get(conn, "/?page=2&per_page=2")

    refute html_response(conn, 200) =~ "Post One"
    refute html_response(conn, 200) =~ "Post Two"
    assert html_response(conn, 200) =~ "Post Three"
  end

  test "don't show drafts if not logged in", %{conn: conn} do
    conn = get(conn, "/?page=1&per_page=20")

    assert html_response(conn, 200) =~ "Post One"
    assert html_response(conn, 200) =~ "Post Two"
    assert html_response(conn, 200) =~ "Post Three"
    refute html_response(conn, 200) =~ "A draft"
  end

  test "don't show posts if user is not in private list", %{conn: conn} do
    conn = get(conn, "/?page=1&per_page=20")

    assert html_response(conn, 200) =~ "Post One"
    assert html_response(conn, 200) =~ "Post Two"
    assert html_response(conn, 200) =~ "Post Three"
    refute html_response(conn, 200) =~ "A private post"
  end

  describe "as admin" do
    setup _ do
      conn =
        session_conn()
        |> put_session(:current_user, %Session{role: :admin, username: "admin"})

      {:ok, %{conn: conn}}
    end

    test "show drafts and privates", %{conn: conn} do
      conn = get(conn, "/?page=1&per_page=20")
      assert html_response(conn, 200) =~ "Post One"
      assert html_response(conn, 200) =~ "Post Two"
      assert html_response(conn, 200) =~ "Post Three"
      assert html_response(conn, 200) =~ "A draft"
      assert html_response(conn, 200) =~ "A private post"
    end
  end

  describe "as user" do
    setup _ do
      conn =
        session_conn()
        |> put_session(:current_user, %Session{role: :user, username: "andi"})

      {:ok, %{conn: conn}}
    end

    test "show private posts if user in private list", %{conn: conn} do
      conn = get(conn, "/?page=1&per_page=20")
      assert html_response(conn, 200) =~ "Post One"
      assert html_response(conn, 200) =~ "Post Two"
      assert html_response(conn, 200) =~ "Post Three"

      refute html_response(conn, 200) =~ "A draft"
      refute html_response(conn, 200) =~ "A private post"

      assert html_response(conn, 200) =~ "Andis post"
    end
  end
end
