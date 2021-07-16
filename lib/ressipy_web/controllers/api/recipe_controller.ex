defmodule RessipyWeb.Api.RecipeController do
  @moduledoc false

  use RessipyWeb, :controller

  alias Ressipy.Recipes

  action_fallback RessipyWeb.Api.FallbackController

  def index(conn, params) do
    with {:ok, filters} <- Recipes.validate_filters(params) do
      recipes = Recipes.list_recipes(filters)
      render(conn, "index.json", recipes: recipes)
    end
  end

  def show(conn, %{"slug" => slug}) do
    with recipe when not is_nil(recipe) <- Recipes.get_recipe(slug) do
      render(conn, "show.json", recipe: recipe)
    end
  end
end
