defmodule RessipyWeb.Api.CategoryController do
  @moduledoc false

  use RessipyWeb, :controller

  alias Ressipy.Recipes

  action_fallback RessipyWeb.Api.FallbackController

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
