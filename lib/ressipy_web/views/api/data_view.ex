defmodule RessipyWeb.Api.DataView do
  @moduledoc false

  use RessipyWeb, :view

  def render("index.json", assigns) do
    %{
      categories: Enum.map(assigns.categories, &category_json/1),
      deleted: deleted_json(assigns.deleted),
      fetched_at: assigns.fetched_at,
      recipes: Enum.map(assigns.recipes, &recipe_json/1)
    }
  end

  defp category_json(category) do
    %{
      name: category.name,
      slug: category.slug
    }
  end

  defp deleted_json(deleted) do
    %{
      categories: deleted.categories,
      recipes: deleted.recipes
    }
  end

  defp ingredient_json(ingredient) do
    %{
      amount: ingredient.amount,
      name: ingredient.ingredient.name
    }
  end

  defp instruction_json(instruction) do
    %{
      text: instruction.text
    }
  end

  defp recipe_json(recipe) do
    %{
      author: recipe.author,
      category: category_json(recipe.category),
      ingredients: Enum.map(recipe.ingredients, &ingredient_json/1),
      instructions: Enum.map(recipe.instructions, &instruction_json/1),
      name: recipe.name,
      slug: recipe.slug
    }
  end
end
