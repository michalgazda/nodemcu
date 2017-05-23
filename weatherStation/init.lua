config = require("config")
main = require("main")

config.ConnectToWifi()

tmr.alarm(0, config.TIME_REFRESH, 1, function() main.main() end)
