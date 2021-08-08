defmodule Ressipy.Recipes.Instruction do
  @moduledoc """
  Represents an instruction in a recipe.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{text: String.t()}

  @primary_key false
  embedded_schema do
    field :text, :string
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = instruction, attrs) do
    instruction
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> validate_length(:text, max: 255)
  end
end
