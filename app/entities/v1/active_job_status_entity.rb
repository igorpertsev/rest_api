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
  expose :fail_reasons, documentation: { type: 'Array', desc: 'List of errors on import' }
  expose :successful_count, documentation: { type: 'Integer', desc: 'Amount of successfuly imported items' }
  expose :job_id, documentation: { type: 'String', desc: 'Job ID' }
end