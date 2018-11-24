$LOAD_PATH.unshift("#{__dir__}/../lib")

require "ayashige"

job = Ayashige::Jobs::CronJob.new
job.perform
