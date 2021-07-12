defmodule Ressipy.Recipes.RecipeListFilters do
  @moduledoc """
  A struct to make it easier to validate paramters given for retrieving the
  list of recipes.
  """

  use Ecto.Schema
  import Ecto.Changeset, only: [apply_action: 2, cast: 3]
  import Ecto.Query, only: [where: 3]

  @type t :: %__MODULE__{
          category: String.t() | nil,
          updated_after: NaiveDateTime.t() | nil
        }

  @primary_key false
  embedded_schema do
    field :category, :string
    field :updated_after, :naive_datetime
  end

  @doc """
  Validate the given filters.
  """
  def validate(params) do
    %__MODULE__{}
    |> cast(params, [:category, :updated_after])
    |> apply_action(:insert)
  end

  @doc """
  Apply filters to the given query.
  """
  @spec apply(Ecto.Query.t(), t) :: Ecto.Query.t()
  def apply(query, params) do
    query
    |> put_category_filter(params.category)
    |> put_updated_after_filter(params.updated_after)
  end

  # Private

  @spec put_category_filter(Ecto.Query.t(), String.t() | nil) :: Ecto.Query.t()
  defp put_category_filter(query, nil), do: query

  defp put_category_filter(query, category_slug) do
    where(query, [category: c], c.slug == ^category_slug)
  end

  @spec put_updated_after_filter(Ecto.Query.t(), NaiveDateTime.t() | nil) :: Ecto.Query.t()
  defp put_updated_after_filter(query, nil), do: query

  defp put_updated_after_filter(query, datetime) do
    where(query, [recipe: r], r.updated_at > ^datetime)
  end
end
