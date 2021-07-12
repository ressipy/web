defmodule RessipyWeb.RecipeController do
  @moduledoc false

  use RessipyWeb, :controller

  alias Ressipy.Authorization
  alias Ressipy.Recipes

  plug RessipyWeb.Authorization, :create_recipe when action in [:create, :new]
  plug RessipyWeb.Authorization, :update_recipe when action in [:edit, :update]
  plug RessipyWeb.Authorization, :delete_recipe when action in [:delete]

  def create(conn, %{"recipe" => recipe_params}) do
    case Recipes.create_recipe(recipe_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe created successfully.")
        |> redirect(to: Routes.recipe_path(conn, :show, recipe.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Recipes.list_categories()

        render(conn, "new.html",
          changeset: changeset,
          categories: categories,
          title: "Create recipe"
        )
    end
  end

  def delete(conn, %{"slug" => slug}) do
    recipe = Recipes.get_recipe!(slug)
    {:ok, _recipe} = Recipes.delete_recipe(recipe)

    conn
    |> put_flash(:info, "Recipe deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :show, recipe.category.slug))
  end

  def edit(conn, %{"slug" => slug}) do
    recipe = Recipes.get_recipe!(slug)
    categories = Recipes.list_categories()
    changeset = Recipes.change_recipe(recipe)

    assigns = [
      recipe: recipe,
      categories: categories,
      changeset: changeset,
      title: "Edit #{recipe.name}"
    ]

    render(conn, "edit.html", assigns)
  end

  def new(conn, params) do
    categories = Recipes.list_categories()

    selected_category =
      case params["category"] do
        nil -> nil
        category -> Enum.find(categories, &(&1.slug == category))
      end

    changeset = Recipes.empty_recipe(selected_category)

    assigns = [
      changeset: changeset,
      categories: categories,
      selected_category: selected_category
    ]

    render(conn, "new.html", assigns)
  end

  def show(conn, %{"slug" => slug}) do
    user = conn.assigns.current_user

    assigns = [
      can_delete: Authorization.can?(user, :delete_recipe),
      can_edit: Authorization.can?(user, :update_recipe),
      recipe: Recipes.get_recipe!(slug)
    ]

    render(conn, "show.html", assigns)
  end

  def update(conn, %{"slug" => slug, "recipe" => recipe_params}) do
    recipe = Recipes.get_recipe!(slug)

    case Recipes.update_recipe(recipe, recipe_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe updated successfully.")
        |> redirect(to: Routes.recipe_path(conn, :show, recipe.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        categories = Recipes.list_categories()

        assigns = [
          recipe: recipe,
          categories: categories,
          changeset: changeset,
          title: "Edit #{recipe.name}"
        ]

        render(conn, "edit.html", assigns)
    end
  end
end
