namespace :resque do
  desc "Restart the resque queue. Use this task for automated deploys"
  task :restart => :environment do
    Rake::Task["resque:stop"].invoke
    Rake::Task["resque:start"].invoke
  end

  desc "Stop the resque queue."
  task :stop => :environment do
    begin
      pid_file = File.new("tmp/pids/resque.pid", "r")
      Process.kill('SIGHUP', pid_file.read.to_i)
    ensure
      pid_file.close
    end
  end

  desc "Start the resque queue. Note: running this command multiple times will create processes that are unstoppable by the stop rake task"
  task :start => :environment do
    child = fork do
      Process.setsid
      ENV["QUEUE"] = "take_screenshot,fetch_metadata"
      Rake::Task["resque:work"].invoke
    end

    pid_file = File.new("tmp/pids/resque.pid", "w")
    begin
      pid_file.write child
    ensure
      Process.detach(child)
      pid_file.close
    end
  end
end
