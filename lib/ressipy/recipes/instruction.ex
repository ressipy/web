defmodule Ressipy.Recipes.Instruction do
  @moduledoc """
  Represents an instruction in a recipe.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Ressipy.Recipes.Recipe

  @type t :: %__MODULE__{
          id: pos_integer,
          inserted_at: NaiveDateTime.t(),
          order: pos_integer,
          recipe: Recipe.t(),
          text: String.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "instructions" do
    field :order, :integer
    field :text, :string

    belongs_to :recipe, Recipe

    timestamps()
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = instruction, attrs) do
    instruction
    |> cast(attrs, [:order, :text])
    |> validate_required([:order, :text])
    |> validate_length(:text, max: 255)
  end
end
