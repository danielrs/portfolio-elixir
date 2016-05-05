defmodule Portfolio.Mailer do
  use Mailgun.Client,
    domain: Application.get_env(:portfolio, :mailgun_domain),
    key: Application.get_env(:portfolio, :mailgun_key)

  def send_contact_email(name, email, subject, text) do
    send_email to: "info@danielrs.me",
               from: email,
               subject: name <> " - " <> subject,
               text: text
  end
end
