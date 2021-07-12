defmodule RessipyWeb.Api.RecipeController do
  @moduledoc false

  use RessipyWeb, :controller

  alias Ressipy.Recipes

  def index(conn, params) do
    with {:ok, filters} <- Recipes.validate_filters(params) do
      recipes = Recipes.list_recipes(filters)
      render(conn, "index.json", recipes: recipes)
    end
  end

  def show(conn, %{"slug" => slug}) do
    recipe = Recipes.get_recipe!(slug)
    render(conn, "show.json", recipe: recipe)
  end
end
