defmodule Portfolio.Mailer do
  @moduledoc """
  Module for sending emails. Note that we don't use the recommended
  configuration specified at https://github.com/chrismccord/mailgun
  because in AWS BeanStalk, the environment variables are not
  available at compile time. Instead, we pass the configuration at
  runtime when it is available.
  """
  require Logger

  def conf() do
    domain = Application.get_env(:portfolio, :mailgun_domain)
    key = Application.get_env(:portfolio, :mailgun_key)
    %{
      domain: domain,
      key: key,
      valid?: domain != nil && key != nil
    }
  end

  def send_contact_email(name, email, subject, text) do
    # Here we pass the configuration at runtime.
    conf = conf()
    error = {:error, "Unable to send email"}

    if conf.valid? do
      res = Mailgun.Client.send_email conf,
              to: "info@danielrs.me",
              from: email,
              subject: name <> " - " <> subject,
              html: Phoenix.View.render_to_string(Portfolio.EmailView, "contact.html", name: name, text: text)
      case res do
        {:ok, _} -> {:ok, nil}
        {:error, status, response} ->
          Logger.error inspect(status) <> " - " <> inspect(response)
          error
      end
    else
      Logger.error "Invalid configuration"
      error
    end
  end
end
