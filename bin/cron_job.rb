$LOAD_PATH.unshift("#{__dir__}/../lib")

require "ayashige"

begin
  job = Ayashige::Jobs::CronJob.new
  job.perform
rescue StandardError => e
  Rollbar.error e
end
