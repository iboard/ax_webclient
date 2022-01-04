defmodule WebClientWeb.SessionView do
  use WebClientWeb, :view

  def admin?(conn) do
    case Plug.Conn.get_session(conn, :current_user) do
      %WebClient.Session{role: :admin} -> true
      _ -> false
    end
  end

  def allow?(conn, :read, resource) do
    (!resource.draft && !resource.private) || admin?(conn)
  end
end
