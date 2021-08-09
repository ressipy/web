defmodule Ressipy.Recipes.Ingredient do
  @moduledoc """
  Represents an ingredient in a recipe.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          amount: String.t(),
          name: String.t()
        }

  @primary_key false
  embedded_schema do
    field :amount, :string
    field :name, :string
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = ingredient, attrs) do
    ingredient
    |> cast(attrs, [:amount, :name])
    |> validate_required([:amount, :name])
    |> validate_length(:name, max: 255)
    |> validate_length(:amount, max: 255)
  end
end
