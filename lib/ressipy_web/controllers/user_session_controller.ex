defmodule RessipyWeb.UserSessionController do
  use RessipyWeb, :controller

  alias Ressipy.Accounts
  alias RessipyWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    case Accounts.get_user_by_email_and_password(email, password) do
      :invalid_login ->
        # In order to prevent user enumeration attacks, don't disclose whether
        # the email is registered.
        render(conn, "new.html", error_message: "Invalid email or password")

      :too_many_attempts ->
        message =
          "Your account has reached the maximum number of failed login attempts and has been temporarily locked. Please try again later."

        render(conn, "new.html", error_message: message)

      user ->
        Logger.metadata(user_id: user.id)
        UserAuth.log_in_user(conn, user, user_params)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
