defmodule Ressipy.Authorization do
  @moduledoc """
  Used to handle whether or not a user can take various actions throughout the
  application.
  """

  @permissions [
    :create_category,
    :create_recipe,
    :delete_category,
    :delete_recipe,
    :update_category,
    :update_recipe,
    :view_admin_panel
  ]

  @doc """
  Receives a user struct and a permission atom and returns whether or not the
  given user is authorized to perform the given action.

  ## Examples

      iex> can?(user, :create_category)
      true

      iex> can?(user, :update_recipe)
      false

  """
  def can?(%{role: :admin}, :create_category), do: true
  def can?(%{role: :editor}, :create_category), do: true

  def can?(%{role: :admin}, :create_recipe), do: true
  def can?(%{role: :editor}, :create_recipe), do: true

  def can?(%{role: :admin}, :delete_category), do: true
  def can?(%{role: :editor}, :delete_category), do: true

  def can?(%{role: :admin}, :delete_recipe), do: true
  def can?(%{role: :editor}, :delete_recipe), do: true

  def can?(%{role: :admin}, :update_category), do: true
  def can?(%{role: :editor}, :update_category), do: true

  def can?(%{role: :admin}, :update_recipe), do: true
  def can?(%{role: :editor}, :update_recipe), do: true

  def can?(%{role: :admin}, :view_admin_panel), do: true

  def can?(_user, _action), do: false

  @doc """
  Receives a user struct and returns a list of the actions that user is
  permitted to take.

  ## Examples

      iex> permissions(user)
      [:create_category, :create_recipe, ...]

  """
  def permissions(user) do
    Enum.filter(@permissions, &can?(user, &1))
  end
end
