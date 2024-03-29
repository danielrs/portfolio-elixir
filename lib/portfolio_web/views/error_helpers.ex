defmodule PortfolioWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    if error = form.errors[field] do
      content_tag :span, translate_error(error), class: "help-block"
    end
  end

  defmacro error_input(input, form, field, opts \\ []) do
    quote do
      opts =  if unquote(form).errors[unquote(field)] do
                Keyword.update(unquote(opts), :class, "input--error", fn x -> x <> " " <> "input--error" end)
              else
                unquote(opts)
              end
      unquote(input)(unquote(form), unquote(field), opts)
    end
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # Because error messages were defined within Ecto, we must
    # call the Gettext module passing our Gettext backend. We
    # also use the "errors" domain as translations are placed
    # in the errors.po file.
    # Ecto will pass the :count keyword if the error message is
    # meant to be pluralized.
    # On your own code and templates, depending on whether you
    # need the message to be pluralized or not, this could be
    # written simply as:
    #
    #     dngettext "errors", "1 file", "%{count} files", count
    #     dgettext "errors", "is invalid"
    #
    if count = opts[:count] do
      Gettext.dngettext(PortfolioWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(PortfolioWeb.Gettext, "errors", msg, opts)
    end
  end
end
