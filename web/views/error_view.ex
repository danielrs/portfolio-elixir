defmodule Portfolio.ErrorView do
  use Portfolio.Web, :view

  def render("404.html", _assigns) do
    render "not_found.html", page_title: "404 not found"
  end

  def render("500.html", _assigns) do
    render "internal_error.html", page_title: "Internal error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
