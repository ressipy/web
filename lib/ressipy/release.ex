defmodule Ressipy.Release do
  @moduledoc """
  Handles housekeeping work associated with keeping things running in
  production.
  """

  alias Ecto.Migrator

  @app :ressipy

  @doc """
  Migrate the database.
  """
  @spec migrate :: no_return
  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Migrator.with_repo(repo, &Migrator.run(&1, :up, all: true))
    end
  end

  @doc """
  Roll the database back to the provided version number.
  """
  @spec rollback(String.t()) :: no_return
  def rollback(version) do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Migrator.with_repo(repo, &Migrator.run(&1, :down, to: version))
    end
  end

  # Private

  @spec load_app :: no_return
  defp load_app do
    Application.load(@app)
  end

  @spec repos :: [module]
  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end
end
