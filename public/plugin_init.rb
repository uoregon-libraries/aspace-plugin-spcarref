Plugins::extend_aspace_routes(File.join(File.dirname(__FILE__), "routes.rb"))

Rails.application.config.after_initialize do
class QuestionMailer < ApplicationMailer
  prepend_view_path "/archivesspace/#{AppConfig[:plugins_directory]}/aspace-plugin-spcarref/public/views"
  def question_received_email(request)
    user_email = request.user_email

    @request = request

    mail(from: from_email,
         to: user_email,
         subject: I18n.t('request.email.subject', :title => request.title),
         template_path: 'mailer')
  end

  def question_received_staff_email(request)
    @request = request

    mail(from: from_email,
         to: email_address(@request, :to),
         subject: I18n.t('request.email.subject', :title => request.title),
         template_path: 'mailer')
  end

  # TODO: not implemented
  # def email_pdf_finding_aid(request, recipient_email, suggested_filename, pdf_path)
  #   attachments[suggested_filename] = File.read(pdf_path)

  #   mail(from: email_address(request),
  #        to: recipient_email,
  #        subject: I18n.t('pdf_reports.your_finding_aid_pdf', :title => record_title))
  # end

  private

  # Adding this as email should always come from the fallback address for our hosted service
  def from_email
    AppConfig[:pui_request_email_fallback_from_address]
  end

  def email_address(request, type = :from)
    use_repo_email = AppConfig[:pui_request_use_repo_email]
    fallback_from  = AppConfig[:pui_request_email_fallback_from_address]
    fallback_to    = AppConfig[:pui_request_email_fallback_to_address]
    begin
      use_repo_email ? request.repo_email : AppConfig[:pui_repos][request.repo_code][:request_email]
    rescue
      type == :from ? fallback_from : fallback_to
    end
  end

end

end
