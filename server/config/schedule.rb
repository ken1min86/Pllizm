env :PATH, ENV['PATH']
set :output, 'log/batch/cron.log'
set :environment, :development
job_type :rbenv_runner, %Q!eval "$(rbenv init -)" ; cd :path && :environment_variable=:environment bin/rails runner :task :output!

every :saturday, at: '5:30 am' do
  rbenv_runner "Batch::Cron::RefractBatch.weekly_set_refract"
end
