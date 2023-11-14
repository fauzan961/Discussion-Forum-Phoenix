defmodule DiscussWeb.UserJSON do
  alias Discuss.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      provider: user.provider,
      token: user.token
    }
  end
end
