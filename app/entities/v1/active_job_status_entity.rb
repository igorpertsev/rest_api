class V1::ActiveJobStatusEntity < Grape::Entity
  expose :status do |status|
    if status.success 
      'success'
    elsif status.success.nil?
      'not finished'
    else
      'failed'
    end
  end
  expose :fail_reasons
  expose :successful_count
  expose :job_id
end