defmodule WebClientWeb.SessionView do
  use WebClientWeb, :view

  def admin?(conn) do
    case Plug.Conn.get_session(conn, :current_user) do
      %WebClient.Session{role: :admin} -> true
      _ -> false
    end
  end

  def allow?(conn, :read, resource) do
    current_user = current_username(conn)

    admin?(conn) ||
      (!resource.draft &&
         !resource.private) ||
      (current_user &&
         String.to_atom(current_user) in (resource.private || []))
  end

  def current_username(conn) do
    case Plug.Conn.get_session(conn, :current_user) do
      %WebClient.Session{} = user -> user.username
      _ -> nil
    end
  end
end
