scheduler = Rufus::Scheduler.new

scheduler.every('1m') do
  User.send_daily_push
end