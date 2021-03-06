defmodule WebClient.Session do
  defstruct username: nil, role: nil

  def login(username, password)

  def login("admin", "secret") do
    %__MODULE__{
      username: "admin",
      role: :admin
    }
  end

  def login("andi", "secret") do
    %__MODULE__{
      username: "andi",
      role: :registered
    }
  end

  def login(_username, _password), do: nil
end
