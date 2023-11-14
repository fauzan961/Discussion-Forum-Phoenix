defmodule DiscussWeb.Router do
  use DiscussWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DiscussWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug RemoteIp
    plug :fetch_session
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug :fetch_current_user
  end

  scope "/", DiscussWeb do
    pipe_through :browser
  end

  # Other scopes may use custom stacks.
  scope "/api", DiscussWeb do
    pipe_through [:api, :fetch_current_user]

    scope "/auth" do
      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
    end

    resources "/topics", TopicController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    get "/signout", AuthController, :signout
    get "/login", AuthController, :login
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:discuss, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DiscussWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  def fetch_current_user(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Discuss.Repo.get(Discuss.Accounts.User, user_id) ->
        Plug.Conn.assign(conn, :current_user, user)

      true ->
        Plug.Conn.assign(conn, :current_user, nil)
    end
  end
end
