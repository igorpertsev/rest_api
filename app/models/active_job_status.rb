class ActiveJobStatus
  include Mongoid::Document

  field :success, type: Boolean, default: nil
  field :fail_reasons, type: Array, default: []
  field :successful_count, type: Integer, default: 0
  field :job_id, type: String
end
