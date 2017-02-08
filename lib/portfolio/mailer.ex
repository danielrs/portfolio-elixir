defmodule Portfolio.Mailer do
  use Mailgun.Client,
    domain: Application.get_env(:portfolio, :mailgun_domain),
    key: Application.get_env(:portfolio, :mailgun_key)

    require Logger

  def send_contact_email(name, email, subject, text) do
    Logger.info Application.get_env(:portfolio, :mailgun_domain)
    Logger.info Application.get_env(:portfolio, :mailgun_key)

    send_email to: "info@danielrs.me",
               from: email,
               subject: name <> " - " <> subject,
               html: Phoenix.View.render_to_string(Portfolio.EmailView, "contact.html", name: name, text: text)
  end
end
