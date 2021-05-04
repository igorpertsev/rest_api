module JobStatus
  class Fetch
    prepend SimpleCommand
    
    def initialize(customer_id, job_id)
      @customer_id = customer_id
      @job_id = job_id
    end
    
    def call
      ::ActiveJobStatus.where(job_id: job_id).first || ::ActiveJobStatus.new
    end
    
    private
    
    attr_accessor :customer_id, :job_id
  end
end
