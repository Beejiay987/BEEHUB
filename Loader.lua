if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Junkie = loadstring(game:HttpGet(
"https://jnkie.com/sdk/library.lua"
))()

Junkie.service = "BeeHuB"
Junkie.identifier = "1075194"
Junkie.provider = "BeeHuB"

local result = Junkie.check_key()

if not result or not result.valid then
    Junkie.get_key_link()
    return warn("Invalid key")
end

getgenv().SCRIPT_KEY = result.key

-- loader signature (anti hotlink)
local LOADER_SIGNATURE = "BeeHuB_SECURE_v1"

local endpoint =
"https://bee-hu-b-core.vercel.app/api/main"
.. "?key=" .. result.key
.. "&loader=" .. LOADER_SIGNATURE

local success, err = pcall(function()
    loadstring(game:HttpGet(endpoint))()
end)

if not success then
    warn("BeeHuB Core load failed:", err)
end
