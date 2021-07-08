defmodule RessipyWeb.CategoryController do
  @moduledoc false

  use RessipyWeb, :controller

  alias Ressipy.Recipes
  alias Ressipy.Recipes.Category

  plug :require_authorization, :create_category when action in [:create, :new]
  plug :require_authorization, :delete_category when action in [:delete]
  plug :require_authorization, :update_category when action in [:edit, :update]

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
    categories = Recipes.list_categories()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Recipes.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"slug" => slug}) do
    category = Recipes.get_category!(slug)
    render(conn, "show.html", category: category)
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
