defmodule Ressipy.Recipes.Category do
  @moduledoc """
  A category is a high level construct that contains many recipes.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Ressipy.Recipes.Recipe
  alias Ressipy.Util

  @type t :: %__MODULE__{
          id: pos_integer,
          inserted_at: NaiveDateTime.t(),
          name: String.t(),
          slug: String.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "categories" do
    field :name, :string
    field :slug, :string

    has_many :recipes, Recipe

    timestamps()
  end

  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = category, attrs) do
    category
    |> cast(attrs, [:name, :slug])
    |> put_slug()
    |> validate_required([:name, :slug])
    |> validate_length(:name, max: 255)
    |> validate_length(:slug, max: 255)
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
