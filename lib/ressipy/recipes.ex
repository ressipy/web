defmodule Ressipy.Recipes do
  @moduledoc """
  Business logic for working with the recipes system.
  """

  import Ecto.Query

  alias Ressipy.Recipes.Category
  alias Ressipy.Recipes.Ingredient
  alias Ressipy.Recipes.Instruction
  alias Ressipy.Recipes.Recipe
  alias Ressipy.Recipes.RecipeIngredient
  alias Ressipy.Recipes.RecipeListFilters
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
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{source: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    Recipe.changeset(recipe, attrs)
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
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
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
  Deletes a Recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` representing a brand new empty recipe.

  ## Examples

      iex> empty_recipe()
      %Ecto.Changeset{source: %Recipe{}}
  """
  @spec empty_recipe(Category.t() | nil) :: Ecto.Changeset.t()
  def empty_recipe(category \\ nil) do
    category_id = if category, do: category.id, else: nil

    recipe = %Recipe{
      category_id: category_id,
      ingredients: [
        %RecipeIngredient{
          order: 1,
          ingredient: %Ingredient{}
        }
      ],
      instructions: [%Instruction{order: 1}]
    }

    change_recipe(recipe)
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
  Returns a list of recipes matching the parameters given.

  ## Examples

  iex> list_recipes()
  [%Recipe{}]

  """
  @spec list_recipes(RecipeListFilters.t()) :: [Recipe.t()]
  def list_recipes(filters) do
    query =
      from r in Recipe,
        as: :recipe,
        left_join: c in assoc(r, :category),
        as: :category,
        left_join: s in assoc(r, :instructions),
        as: :instructions,
        left_join: j in assoc(r, :ingredients),
        as: :recipe_ingredients,
        left_join: g in assoc(j, :ingredient),
        as: :ingredient,
        preload: [
          category: c,
          ingredients: {j, ingredient: g},
          instructions: s
        ],
        order_by: [j.order, s.order]

    query
    |> RecipeListFilters.apply(filters)
    |> Repo.all()
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

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Validate the given filters to ensure that they can be applied to the recipe
  list query.
  """
  @spec validate_filters(map) :: {:ok, RecipeListFilters.t()} | {:error, Ecto.Changeset.t()}
  def validate_filters(params) do
    RecipeListFilters.validate(params)
  end
end
