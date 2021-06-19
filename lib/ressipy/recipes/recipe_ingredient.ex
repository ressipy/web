defmodule Ressipy.Recipes.RecipeIngredient do
  @moduledoc """
  Struct used specifically for joining ingredients to recipes.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Ressipy.Recipes.Ingredient
  alias Ressipy.Recipes.Recipe

  @type t :: %__MODULE__{
          amount: String.t(),
          id: pos_integer,
          ingredient: Ingredient.t(),
          inserted_at: NaiveDateTime.t(),
          order: String.t(),
          recipe: Recipe.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "recipe_ingredients" do
    field :amount, :string
    field :order, :integer

    belongs_to :recipe, Recipe
    belongs_to :ingredient, Ingredient

    timestamps()
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = ingredient, attrs) do
    ingredient
    |> cast(attrs, [:amount, :order])
    |> cast_assoc(:ingredient, required: true, with: &Ingredient.changeset/2)
    |> validate_required([:amount, :order])
    |> validate_length(:amount, max: 255)
  end
end
