defmodule Ressipy.RateLimiting do
  @moduledoc """
  Allows for simple rate limiting to be put in place to prevent users from
  being able to perform actions more than they reasonably should.
  """

  require Logger

  def check_rate(:attempt_login, params) do
    # Allow users to attempt to log in only 5 times in an hour, and deny login
    # attempts if there's any kind of error
    case Hammer.check_rate("attempt_login:#{params.email}", 60_000 * 60, 5) do
      {:allow, _} ->
        :allow

      {:deny, _} ->
        :deny

      {:error, error} ->
        Logger.error("Error when checking rate limit for login: #{inspect(error)}")
        :deny
    end
  end
end
