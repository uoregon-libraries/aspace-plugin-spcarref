require 'active_model'

class Question < RequestItem
  attr_accessor :collection, :consulted, :question

  def to_text_array(skip_empty = false)
    arr = []
    %i(user_name user_email date note title identifier cite request_uri resource_name resource_id repo_name hierarchy restrict).each do |sym|
      arr.push("#{sym.to_s}: #{self[sym]}") unless skip_empty && self[sym].blank?
    end
    arr.push("machine: #{self[:machine].blank? ? '' : self[:machine].join(', ')}")
    arr
  end
end

