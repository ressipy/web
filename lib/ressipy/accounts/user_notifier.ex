defmodule Ressipy.Accounts.UserNotifier do
  @moduledoc """
  For several actions, the user needs to be notified. This module is
  responsible for sending those notifications to the appropriate user.
  """

  use Phoenix.Swoosh, view: RessipyMailer.AccountsView
  import Swoosh.Email
  alias RessipyMailer, as: Mailer

  @from_address {"Ressipy", "no-reply@ressipy.com"}

  @doc """
  Deliver instructions to confirm account.
  """
  @spec deliver_confirmation_instructions(User.t(), String.t()) ::
          {:ok, Bamboo.Email.t()} | {:error, Exception.t() | String.t()}
  def deliver_confirmation_instructions(user, url) do
    assigns = %{user: user, url: url}
    deliver(user, "Confirm your Ressipy account", :confirm_email, assigns)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  @spec deliver_reset_password_instructions(User.t(), String.t()) ::
          {:ok, Bamboo.Email.t()} | {:error, Exception.t() | String.t()}
  def deliver_reset_password_instructions(user, url) do
    assigns = %{user: user, url: url}
    deliver(user, "Reset your password for Ressipy", :reset_password, assigns)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  @spec deliver_update_email_instructions(User.t(), String.t()) ::
          {:ok, Bamboo.Email.t()} | {:error, Exception.t() | String.t()}
  def deliver_update_email_instructions(user, url) do
    assigns = %{user: user, url: url}
    deliver(user, "Change your email address for Ressipy", :change_email, assigns)
  end

  # Private

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, template, assigns) do
    email =
      new()
      |> to(recipient)
      |> from(@from_address)
      |> subject(subject)
      |> render_body(template, assigns)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end
end
