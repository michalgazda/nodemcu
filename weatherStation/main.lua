local main = {}

main.ADDRESS = 'http://api.thingspeak.com/update.json'
main.CONTENT_TYPE = 'Content-Type: application/json\r\n'
main.API_KEY = '"api_key":"Z24YXSYGVUHK3D28"'

local function goSleep()
    print("Going to deep sleep for " .. (config.TIME_SENSOR_READINGS / config.SEC) .. " seconds")
    node.dsleep(config.TIME_SENSOR_READINGS * config.SEC)
end

local function goShortSleep()
    print("Going to deep sleep for " .. (config.TIME_SHORT_SLEEP / config.SEC) .. " seconds")
    node.dsleep(config.TIME_SHORT_SLEEP * config.SEC)
end

local function dthRead()
    local tempFin = 0
    local humidityFin = 0
    local count = 0
    for i = 1, 5 do
        local status, temp, humi, temp_dec, humi_dec = dht.read(config.PIN_DTH)
        if status == dht.OK then
            tempFin = tempFin + temp
            humidityFin = humidityFin + humi
            count = count + 1
            tmr.delay(200)
        end
    end
    return tempFin / count, humidityFin / count
end

local function sendPost(temp, humi)
    http.post(main.ADDRESS,
        main.CONTENT_TYPE,
        '{' .. main.API_KEY .. ',"field1":"' .. temp .. '","field2":"' .. humi .. '" }',
        function(code, data)
            if (code < 0) then
                print("HTTP request failed")
                goShortSleep()
            else
                print(code, data)
                goSleep() --post is asynchronous, needs to sleep after it finishes not in main
            end
        end)
end

function main.main()
    if wifi.sta.status() == wifi.STA_GOTIP then
        tmr.stop(0)
        local temp, humi = dthRead()
        sendPost(temp, humi)
        print("OK")
    else
        print("Connecting...")
    end
end

return main
