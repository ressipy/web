defmodule RessipyWeb.MetaTags do
  @moduledoc false

  import Phoenix.HTML, only: [sigil_E: 2]

  @type t :: %__MODULE__{
          description: String.t() | nil,
          image: String.t() | nil,
          og_site_name: String.t(),
          og_type: String.t(),
          title: String.t() | nil,
          twitter_card: String.t(),
          twitter_site: String.t(),
          url: String.t() | nil
        }

  defstruct description: nil,
            image: nil,
            og_site_name: "Ressipy",
            og_type: "website",
            title: "Ressipy",
            twitter_card: "summary",
            twitter_site: "@dnsbty",
            url: nil

  def render_meta_tags(meta_tags) do
    meta_tags = meta_tags || %__MODULE__{}
    tags = for {tag, value} <- Map.from_struct(meta_tags), do: render_tag(tag, value)

    ~E"""
    <%= for {:safe, _} = rendered <- tags, do: rendered %>
    """
  end

  defp render_tag(_, nil), do: nil

  defp render_tag(:description, description) do
    ~E"""
    <meta name="description" property="og:description" content="<%= description %>">
    """
  end

  defp render_tag(:image, image) do
    ~E"""
    <meta property="og:image" content="<%= image %>">
    """
  end

  defp render_tag(:og_site_name, site_name) do
    ~E"""
    <meta property="og:site_name" content="<%= site_name %>">
    """
  end

  defp render_tag(:og_type, type) do
    ~E"""
    <meta property="og:type" content="<%= type %>">
    """
  end

  defp render_tag(:title, title) do
    ~E"""
    <meta name="title" property="og:title" content="<%= title %>">
    """
  end

  defp render_tag(:twitter_card, card) do
    ~E"""
    <meta property="twitter:card" content="<%= card %>">
    """
  end

  defp render_tag(:twitter_site, site) do
    ~E"""
    <meta property="twitter:site" content="<%= site %>">
    """
  end

  defp render_tag(:url, url) do
    ~E"""
    <meta property="og:url" content="<%= url %>">
    """
  end
end
