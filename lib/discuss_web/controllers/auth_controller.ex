defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  alias Discuss.Repo
  plug Ueberauth, base_path: "/api/auth"

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_data = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}

    case findOrCreateUser(user_data) do
      {:ok, user} ->
        conn = put_session(conn, :user_id, user.id)
        redirect(conn, to: "/api/topics")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: "/")
    end
  end

  def signout(conn, _params) do
    conn =
      conn
      |> configure_session(drop: true)

    json(conn, %{message: "Signed out"})
  end

  def login(conn, _params) do
    conn = put_session(conn, :user_id, 1)
    json(conn, %{message: "Logged in"})
  end

  defp findOrCreateUser(user_data) do
    case Repo.get_by(Discuss.Accounts.User, email: user_data.email) do
      nil ->
        Discuss.Accounts.create_user(user_data)

      user ->
        {:ok, user}
    end
  end
end
