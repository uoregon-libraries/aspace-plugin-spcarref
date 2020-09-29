Rails.application.routes.draw do

  post 'push_question' => 'questions#process_question'

end
