app_directory = ENV['SMEAGOL_PATH']
worker_processes 1
working_directory app_directory
listen "unix:#{app_directory}/unicorn/smeagol.sock", backlog: 1024
timeout 60
user ENV['SMEAGOL_USER'], ENV['SMEAGOL_GROUP']
File.umask(027)
preload_app true
pid "#{app_directory}/unicorn/smeagol.pid"
stderr_path "#{app_directory}/unicorn/smeagol.stderr.log"
stdout_path "#{app_directory}/unicorn/smeagol.stdout.log"
