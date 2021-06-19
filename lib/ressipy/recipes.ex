defmodule Ressipy.Recipes do
  @moduledoc """
  Business logic for working with the recipes system.
  """

  import Ecto.Query

  alias Ressipy.Recipes.Category
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
    Repo.get_by!(Category, slug: slug)
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
end
