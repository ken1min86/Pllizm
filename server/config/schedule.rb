require File.expand_path(File.dirname(__FILE__) + "/environment")

ENV.each { |k, v| env(k, v) }

set :output, error: 'log/batch/cron_error.log', standard: 'log/batch/cron.log'

every :friday, at: '8:30 pm' do # UTCで指定している。JSTでは土曜日のAM5:30に作動する。
  runner 'Batch::Cron::RefractBatch.weekly_set_refract'
end
