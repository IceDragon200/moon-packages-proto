require 'es/taggable'

module Moon
  class Scheduler
    module Jobs
      class Base
        include Moon::Taggable

        attr_writer :tags

        def tags
          @tags ||= []
        end
      end
    end

    def print_jobs
      table = []
      l = Moon::Logfmt::Logger.new(module: 'scheduler')
      l.timestamp = false
      @jobs.each do |job|
        case job
        when Moon::Scheduler::Jobs::TimeBase
          l.write(job: job.class.to_s.demodulize,
                  time: "#{job.time}/#{job.duration}",
                  tags: job.tags)
        else
          l.write(job: job.class.to_s.demodulize,
                  tags: job.tags)
        end
      end
    end
  end
end
