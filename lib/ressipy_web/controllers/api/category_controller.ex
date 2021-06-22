defmodule RessipyWeb.Api.CategoryController do
  @moduledoc false

  use RessipyWeb, :controller

  alias Ressipy.Recipes

  def index(conn, _params) do
    categories = Recipes.list_categories()
    render(conn, "index.json", categories: categories)
  end

  def show(conn, %{"slug" => slug}) do
    category = Recipes.get_category!(slug)
    render(conn, "show.json", category: category)
  end
end
