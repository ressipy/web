defmodule RessipyWeb.Api.RecipeController do
  @moduledoc false

  use RessipyWeb, :controller

  alias Ressipy.Recipes

  def show(conn, %{"slug" => slug}) do
    recipe = Recipes.get_recipe!(slug)
    render(conn, "show.json", recipe: recipe)
  end
end
