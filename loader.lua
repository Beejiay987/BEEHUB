if not getgenv().SCRIPT_KEY then
    return warn("Key not verified")
end

local VERSION = "1.0"
local SIGNATURE = "BeeHuB_SECURE_v1"

local endpoint =
"https://bee-hu-b-core.vercel.app/api/main"
.. "?key=" .. getgenv().SCRIPT_KEY
.. "&loader=" .. SIGNATURE
.. "&version=" .. VERSION

local success, result = pcall(function()
    return game:HttpGet(endpoint)
end)

if not success then
    return warn("Loader request failed")
end

if result == "OUTDATED_LOADER" then
    return warn("Please update BeeHuB loader")
end

loadstring(result)()
