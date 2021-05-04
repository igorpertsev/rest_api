FactoryBot.define do
  factory :job_status, class: ActiveJobStatus do
    success { true } 
    fail_reasons { [] } 
    successful_count { 5 } 
    job_id { SecureRandom.hex(5) } 
  end
end