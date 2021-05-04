module JobStatus
  class Fetch
    prepend SimpleCommand
    
    def initialize(job_id)
      @job_id = job_id
    end
    
    def call
      ::ActiveJobStatus.where(job_id: job_id).first || ::ActiveJobStatus.new
    end
    
    private
    
    attr_accessor :job_id
  end
end
