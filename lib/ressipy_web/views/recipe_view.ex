defmodule RessipyWeb.RecipeView do
  @moduledoc false

  use RessipyWeb, :view

  @spec for_select([Ressipy.Recipes.Category.t()]) :: [{String.t(), integer}]
  def for_select(categories) do
    Enum.map(categories, &{&1.name, &1.slug})
  end

  @spec has_id?(Phoenix.HTML.Form.t()) :: boolean()
  def has_id?(form) do
    !!form.data.id
  end
end
