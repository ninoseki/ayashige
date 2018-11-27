$LOAD_PATH.unshift("#{__dir__}/../lib")

require "ayashige"

def with_error_handling
  yield
rescue StandardError => e
  if Ayashige::Rollbar.available?
    Rollbar.error e
  else
    puts e
  end
end

with_error_handling { Ayashige::Sources::WebAnalyzer.new.store_newly_registered_domains }
with_error_handling { Ayashige::Sources::WhoisDS.new.store_newly_registered_domains }
