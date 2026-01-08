class ApplicationMailer < ActionMailer::Base
  helper EmailHelper

  default from: '"BibliographyGR Accounts" <accounts@bibliography.gr>'
  layout 'mailer'
end
