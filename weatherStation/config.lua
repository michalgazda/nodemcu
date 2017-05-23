local config = {}

config.WIFI_SSID = "SSID_HERE"
config.WIFI_PASSWORD = "PASS_HERE"

-- times in ms
config.TIME_SENSOR_READINGS = 18000000
config.TIME_SHORT_SLEEP = 3000
config.TIME_REFRESH = 1000
config.SEC = 1000

-- GPIO Configuration
config.PIN_DTH = 1

function config.ConnectToWifi()
    wifi.setmode(wifi.STATION)
    wifi.setphymode(wifi.PHYMODE_N)
    wifi.sta.config(config.WIFI_SSID, config.WIFI_PASSWORD)
    wifi.sta.connect()
end

return config
