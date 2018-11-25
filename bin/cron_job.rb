$LOAD_PATH.unshift("#{__dir__}/../lib")

require "ayashige"

begin
  job = Ayashige::Jobs::CronJob.new
  job.perform
rescue StandardError => e
  if Ayashige::Rollbar.available?
    Rollbar.error e
  else
    puts e
  end
end
