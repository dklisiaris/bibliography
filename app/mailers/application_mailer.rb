class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)

  default from: '"BibliographyGR Accounts" <accounts@bibliography.gr>'
  layout 'mailer'
end
