scheduler = Rufus::Scheduler.new

scheduler.every("15m") do
  User.send_daily_push
end