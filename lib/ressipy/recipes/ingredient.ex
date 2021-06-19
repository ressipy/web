defmodule Ressipy.Recipes.Ingredient do
  @moduledoc """
  Represents an ingredient.

  Ingredients have a many-to-many relationship with recipes. This means that
  potentially an ingredient could be used in many different recipes, and at
  some point we can support finding recipes that work with the ingredients on
  hand.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Ressipy.Recipes.Recipe

  @type t :: %__MODULE__{
          id: pos_integer,
          inserted_at: NaiveDateTime.t(),
          name: String.t(),
          recipes: [Recipe.t()],
          updated_at: NaiveDateTime.t()
        }

  schema "ingredients" do
    field :name, :string

    many_to_many :recipes, Recipe, join_through: "recipe_ingredients"

    timestamps()
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, max: 255)
  end
end
