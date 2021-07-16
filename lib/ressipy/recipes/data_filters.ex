defmodule Ressipy.Recipes.DataFilters do
  @moduledoc """
  A struct to make it easier to validate paramters given for retrieving all the
  data when syncing.
  """

  use Ecto.Schema
  import Ecto.Changeset, only: [apply_action: 2, cast: 3]
  import Ecto.Query, only: [where: 3]

  @type t :: %__MODULE__{
          updated_after: NaiveDateTime.t() | nil
        }

  @primary_key false
  embedded_schema do
    field :updated_after, :naive_datetime
  end

  @doc """
  Validate the given filters.
  """
  def validate(params) do
    %__MODULE__{}
    |> cast(params, [:updated_after])
    |> apply_action(:insert)
  end

  @doc """
  Apply filters to the given query.
  """
  @spec apply(Ecto.Query.t(), t, atom) :: Ecto.Query.t()
  def apply(query, params, target) do
    put_updated_after_filter(query, params.updated_after, target)
  end

  # Private

  @spec put_updated_after_filter(Ecto.Query.t(), NaiveDateTime.t() | nil, atom) :: Ecto.Query.t()
  defp put_updated_after_filter(query, nil, _target), do: query

  defp put_updated_after_filter(query, datetime, target) do
    where(query, [{^target, t}], t.updated_at > ^datetime)
  end
end
