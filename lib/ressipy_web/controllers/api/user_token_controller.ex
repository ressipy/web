defmodule RessipyWeb.Api.UserTokenController do
  @moduledoc false

  use RessipyWeb, :controller
  alias Ressipy.Accounts
  alias Ressipy.Authorization

  action_fallback RessipyWeb.Api.FallbackController

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    with %{} = user <- Accounts.get_user_by_email_and_password(email, password) do
      Logger.metadata(user_id: user.id)
      permissions = Authorization.permissions(user)

      token =
        user
        |> Accounts.generate_user_session_token()
        |> Base.encode64(padding: false)

      render(conn, :create, permissions: permissions, token: token)
    end
  end
end
