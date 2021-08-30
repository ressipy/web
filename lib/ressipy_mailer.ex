defmodule RessipyMailer do
  @moduledoc """
  This module does all the work of sending out emails.
  """

  use Swoosh.Mailer, otp_app: :ressipy
end
