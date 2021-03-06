defmodule RessipyWeb.Api.RecipeController do
  @moduledoc false

  use RessipyWeb, :controller

  alias Ressipy.Recipes

  action_fallback RessipyWeb.Api.FallbackController

  plug RessipyWeb.Authorization, :create_recipe when action in [:create]
  plug RessipyWeb.Authorization, :update_recipe when action in [:update]
  plug RessipyWeb.Authorization, :delete_recipe when action in [:delete]

  def create(conn, %{"recipe" => recipe_params}) do
    with {:ok, recipe} <- Recipes.create_recipe(recipe_params) do
      recipe = Recipes.load_category(recipe)
      render(conn, :show, recipe: recipe)
    end
  end

  def delete(conn, %{"slug" => slug}) do
    recipe = Recipes.get_recipe!(slug)
    {:ok, _recipe} = Recipes.delete_recipe(recipe)

    render(conn, :show, recipe: recipe)
  end

  def index(conn, params) do
    with {:ok, filters} <- Recipes.validate_filters(params) do
      recipes = Recipes.list_recipes(filters)
      render(conn, :index, recipes: recipes)
    end
  end

  def show(conn, %{"slug" => slug}) do
    with recipe when not is_nil(recipe) <- Recipes.get_recipe(slug) do
      render(conn, :show, recipe: recipe)
    end
  end

  def update(conn, %{"slug" => slug, "recipe" => recipe_params}) do
    recipe = Recipes.get_recipe!(slug)

    with {:ok, recipe} <- Recipes.update_recipe(recipe, recipe_params) do
      render(conn, :show, recipe: recipe)
    end
  end
end
