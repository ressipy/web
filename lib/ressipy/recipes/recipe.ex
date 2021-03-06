defmodule Ressipy.Recipes.Recipe do
  @moduledoc """
  Represents a recipe.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Ressipy.Recipes.Category
  alias Ressipy.Recipes.Instruction
  alias Ressipy.Recipes.Ingredient
  alias Ressipy.Util

  @type t :: %__MODULE__{
          author: String.t() | nil,
          category: Category.t(),
          default_image: String.t() | nil,
          ingredients: [Ingredient.t()],
          instructions: [Instruction.t()],
          name: String.t(),
          slug: String.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "recipes" do
    field :author, :string
    field :default_image, :string
    field :name, :string
    field :slug, :string

    belongs_to :category, Category, foreign_key: :category_slug, references: :slug, type: :string
    embeds_many :ingredients, Ingredient, on_replace: :delete
    embeds_many :instructions, Instruction, on_replace: :delete

    timestamps()
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :author, :default_image, :category_slug])
    |> cast_embed(:instructions, required: true, with: &Instruction.changeset/2)
    |> cast_embed(:ingredients, required: true, with: &Ingredient.changeset/2)
    |> put_slug()
    |> validate_required([:name, :category_slug])
    |> validate_length(:author, max: 255)
    |> validate_length(:default_image, max: 255)
    |> validate_length(:name, max: 255)
    |> foreign_key_constraint(:category_slug)
    |> unique_constraint(:slug)
  end

  @spec put_slug(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp put_slug(changeset) do
    case fetch_change(changeset, :name) do
      {:ok, name} ->
        slug = Util.slugify(name)
        put_change(changeset, :slug, slug)

      :error ->
        changeset
    end
  end
end
