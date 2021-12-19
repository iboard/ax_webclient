defmodule WebClientWeb.SessionView do
  use WebClientWeb, :view

  def admin?(conn) do
    case Plug.Conn.get_session(conn, :current_user) do
      %{admin: true} -> true
      _ -> false
    end
  end
end
