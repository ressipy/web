defmodule RessipyWeb.CategoryController do
  @moduledoc false

  use RessipyWeb, :controller

  alias Ressipy.Authorization
  alias Ressipy.Recipes
  alias Ressipy.Recipes.Category

  plug RessipyWeb.Authorization, :create_category when action in [:create, :new]
  plug RessipyWeb.Authorization, :delete_category when action in [:delete]
  plug RessipyWeb.Authorization, :update_category when action in [:edit, :update]

  def create(conn, %{"category" => category_params}) do
    case Recipes.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category.slug))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"slug" => slug}) do
    category = Recipes.get_category!(slug)
    {:ok, _category} = Recipes.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :index))
  end

  def edit(conn, %{"slug" => slug}) do
    category = Recipes.get_category!(slug)
    changeset = Recipes.change_category(category)
    title = "Edit #{category.name}"
    render(conn, "edit.html", category: category, changeset: changeset, title: title)
  end

  def index(conn, _params) do
    assigns = [
      can_create: Authorization.can?(conn.assigns.current_user, :create_category),
      categories: Recipes.list_categories()
    ]

    render(conn, "index.html", assigns)
  end

  def new(conn, _params) do
    changeset = Recipes.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"slug" => slug}) do
    assigns = [
      can_add: Authorization.can?(conn.assigns.current_user, :create_recipe),
      can_delete: Authorization.can?(conn.assigns.current_user, :delete_category),
      can_edit: Authorization.can?(conn.assigns.current_user, :update_category),
      category: Recipes.get_category!(slug)
    ]

    render(conn, "show.html", assigns)
  end

  def update(conn, %{"slug" => slug, "category" => category_params}) do
    category = Recipes.get_category!(slug)

    case Recipes.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category.slug))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end
end
