class QuestionsController < ApplicationController

include PrefixHelper

  def process_question
    @request = Question.new(params)
    @request.collection = params['collection']
    @request.question = params['question']
    @request.consulted = params['consulted']
    year = Time.zone.now.strftime('%Y')
    errs = @request.validate
    if params["comment"].present? ||
       params["personhood"] != 'n' ||
       params['current_year'] != year
      errs << I18n.t('request.failed')
    end
    if errs.blank?
      flash[:notice] = I18n.t('request.submitted')
      QuestionMailer.question_received_staff_email(@request).deliver
      QuestionMailer.question_received_email(@request).deliver
      redirect_to params.fetch('base_url', app_prefix(request[:request_uri]))
    else
      flash[:error] = errs
      redirect_back(fallback_location: app_prefix(request[:request_uri])) and return
    end
  end
end
