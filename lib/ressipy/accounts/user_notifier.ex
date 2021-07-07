defmodule Ressipy.Accounts.UserNotifier do
  @moduledoc """
  For several actions, the user needs to be notified. This module is
  responsible for sending those notifications to the appropriate user.
  """

  use Bamboo.Phoenix, view: RessipyMailer.AccountsView
  import Bamboo.Email
  alias RessipyMailer, as: Mailer

  @from_address {"Ressipy", "no-reply@ressipy.com"}

  @doc """
  Deliver instructions to confirm account.
  """
  @spec deliver_confirmation_instructions(User.t(), String.t()) ::
          {:ok, Bamboo.Email.t()} | {:error, Exception.t() | String.t()}
  def deliver_confirmation_instructions(user, url) do
    new_email()
    |> from(@from_address)
    |> to(user.email)
    |> subject("Confirm your Ressipy account")
    |> assign(:user, user)
    |> assign(:url, url)
    |> render(:confirm_email)
    |> Mailer.deliver_now()
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  @spec deliver_reset_password_instructions(User.t(), String.t()) ::
          {:ok, Bamboo.Email.t()} | {:error, Exception.t() | String.t()}
  def deliver_reset_password_instructions(user, url) do
    new_email()
    |> from(@from_address)
    |> to(user.email)
    |> subject("Reset your password for Ressipy")
    |> assign(:user, user)
    |> assign(:url, url)
    |> render(:reset_password)
    |> Mailer.deliver_now()
  end

  @doc """
  Deliver instructions to update a user email.
  """
  @spec deliver_update_email_instructions(User.t(), String.t()) ::
          {:ok, Bamboo.Email.t()} | {:error, Exception.t() | String.t()}
  def deliver_update_email_instructions(user, url) do
    new_email()
    |> from(@from_address)
    |> to(user.email)
    |> subject("Change your email address for Ressipy")
    |> assign(:user, user)
    |> assign(:url, url)
    |> render(:change_email)
    |> Mailer.deliver_now()
  end
end
