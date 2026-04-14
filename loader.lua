print("BeeHuB Debug: Loader started")

if not getgenv().SCRIPT_KEY then
    warn("BeeHuB Debug: SCRIPT_KEY missing")
    return
end

print("BeeHuB Debug: SCRIPT_KEY OK")

local VERSION = "1.0"
local SIGNATURE = "BeeHuB_SECURE_v1"

local endpoint =
"https://bee-hu-b-core.vercel.app/api/main"
.. "?key=" .. getgenv().SCRIPT_KEY
.. "&loader=" .. SIGNATURE
.. "&version=" .. VERSION

print("BeeHuB Debug: Requesting endpoint...")
print(endpoint)

local success, response = pcall(function()
    return game:HttpGet(endpoint)
end)

if not success then
    warn("BeeHuB Debug: HTTP request failed")
    warn(response)
    return
end

print("BeeHuB Debug: Endpoint response received")

if response == "Missing key" then
    warn("BeeHuB Debug: Server says key missing")
    return
end

if response == "Invalid key" then
    warn("BeeHuB Debug: Key invalid")
    return
end

if response == "Unauthorized loader" then
    warn("BeeHuB Debug: Loader signature rejected")
    return
end

if response == "OUTDATED_LOADER" then
    warn("BeeHuB Debug: Loader version outdated")
    return
end

print("BeeHuB Debug: Executing main.lua")

local executed, err = pcall(function()
    loadstring(response)()
end)

if not executed then
    warn("BeeHuB Debug: main.lua execution failed")
    warn(err)
    return
end

print("BeeHuB Debug: main.lua executed successfully")
