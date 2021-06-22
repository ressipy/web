defmodule RessipyWeb.Api.RecipeView do
  @moduledoc false

  use RessipyWeb, :view

  def render("show.json", %{recipe: recipe}) do
    %{
      author: recipe.author,
      category: category_json(recipe.category),
      ingredients: Enum.map(recipe.ingredients, &ingredient_json/1),
      instructions: Enum.map(recipe.instructions, &instruction_json/1),
      name: recipe.name,
      slug: recipe.slug
    }
  end

  defp category_json(category) do
    %{
      name: category.name,
      slug: category.slug
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
end
