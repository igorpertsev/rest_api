require 'securerandom'

class BulkImportJob < ApplicationJob
  queue_as :default

  def perform(job_id, customer_id, contracts_data)
    command = ::Contracts::BulkImport.call(customer_id, contracts_data)

    ::ActiveJobStatus.create(job_id: job_id, success: command.success?, fail_reasons: command.errors.full_messages, 
      successful_count: command.result)
  end
end
