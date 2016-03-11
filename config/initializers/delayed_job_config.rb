Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 5
Delayed::Worker.max_attempts = 10
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.logger.level = 0

# Silence DJ querying AR frequently.
module SilentJob
  def reserve(*args)
    ActiveRecord::Base.logger.silence { super(*args) }
  end
end
Delayed::Backend::ActiveRecord::Job.singleton_class.prepend(SilentJob)
