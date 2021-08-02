defmodule RessipyWeb.ErrorView do
  use RessipyWeb, :view

  def render("400.json", %{changeset: changeset}) do
    errors =
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    %{error: %{type: :bad_request, description: errors}}
  end

  def render("401.json", %{error: :invalid_login}) do
    %{error: %{type: :unauthenticated, description: "Invalid email or password"}}
  end

  def render("404.json", _) do
    %{error: %{type: :not_found, description: "The specified resource could not be found"}}
  end

  def render("429.json", _) do
    %{
      error: %{
        type: :too_many_requests,
        description:
          "You have attempted this action too many times. Please wait before trying again."
      }
    }
  end

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
