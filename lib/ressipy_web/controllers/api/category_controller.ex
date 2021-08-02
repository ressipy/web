defmodule RessipyWeb.Api.CategoryController do
  @moduledoc false

  use RessipyWeb, :controller

  alias Ressipy.Recipes

  action_fallback RessipyWeb.Api.FallbackController

  plug RessipyWeb.Authorization, :create_category when action in [:create]
  plug RessipyWeb.Authorization, :delete_category when action in [:delete]

  def create(conn, %{"category" => category_params}) do
    with {:ok, category} <- Recipes.create_category(category_params) do
      render(conn, :show, category: category)
    end
  end

  def delete(conn, %{"slug" => slug}) do
    category = Recipes.get_category!(slug)
    {:ok, _category} = Recipes.delete_category(category)

    render(conn, :show, category: category)
  end

  def index(conn, params) do
    with {:ok, filters} <- Recipes.validate_filters(params) do
      categories = Recipes.list_categories(filters)
      render(conn, "index.json", categories: categories)
    end
  end

  def show(conn, %{"slug" => slug}) do
    category = Recipes.get_category!(slug)
    render(conn, "show.json", category: category)
  end
end
