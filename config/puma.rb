# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
# Puma can serve each request in a thread from an internal thread pool.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/puma.pid" }

# Specifies the `bind` (UNIXソケット)
#bind "unix:///home/ubuntu/game_review_app/tmp/sockets/puma.sock"
port ENV.fetch("PORT") { 3000 }
# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# 本番環境用のワーカー設定
if ENV.fetch("RAILS_ENV") == "production"
  workers ENV.fetch("WEB_CONCURRENCY") { 2 }
  preload_app!
  
  # ログ出力
  stdout_redirect(
    "log/puma.stdout.log",
    "log/puma.stderr.log",
    true
  )
end
