defmodule RessipyWeb.Api.CategoryView do
  @moduledoc false

  use RessipyWeb, :view

  def render("index.json", %{categories: categories}) do
    %{
      categories: Enum.map(categories, &category_json/1)
    }
  end

  def render("show.json", %{category: category}) do
    %{
      category: category_json(category)
    }
  end

  defp category_json(%{recipes: %Ecto.Association.NotLoaded{}} = category) do
    %{
      name: category.name,
      slug: category.slug
    }
  end

  defp category_json(category) do
    %{
      name: category.name,
      recipes: Enum.map(category.recipes, &recipe_json/1),
      slug: category.slug
    }
  end

  defp recipe_json(recipe) do
    %{
      name: recipe.name,
      slug: recipe.slug
    }
  end
end
