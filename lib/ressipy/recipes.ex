defmodule Ressipy.Recipes do
  @moduledoc """
  Business logic for working with the recipes system.
  """

  import Ecto.Query

  alias Ressipy.Recipes.Category
  alias Ressipy.Recipes.Recipe
  alias Ressipy.Repo

  @doc """
  Returns an `Ecto.Changeset` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  @spec change_category(Category.t(), map) :: Ecto.Changeset.t()
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  @doc """
  Creates a new category.

  ## Examples

      iex> create_cateogry(%{name: "Appetizers"})
      {:ok, %Category{}}

      iex> create_category(%{})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_category(map) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def create_category(attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!("main-dishes")
      %Category{}

      iex> get_category!("abcd")
      ** (Ecto.NoResultsError)

  """
  @spec get_category!(String.t()) :: Category.t()
  def get_category!(slug) do
    query =
      from c in Category,
        left_join: r in assoc(c, :recipes),
        preload: [recipes: r],
        order_by: r.name

    Repo.get_by!(query, slug: slug)
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!("chicken-parmesan")
      %Recipe{}

      iex> get_recipe!("cake")
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(slug) do
    query =
      from r in Recipe,
        left_join: c in assoc(r, :category),
        left_join: s in assoc(r, :instructions),
        left_join: j in assoc(r, :ingredients),
        left_join: g in assoc(j, :ingredient),
        preload: [
          category: c,
          ingredients: {j, ingredient: g},
          instructions: s
        ],
        order_by: [j.order, s.order]

    Repo.get_by!(query, slug: slug)
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  @spec list_categories :: [Category.t()]
  def list_categories do
    query = from c in Category, order_by: c.name
    Repo.all(query)
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end
end
