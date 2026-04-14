local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()

Junkie.service = "BeeHuB"
Junkie.identifier = "1075194"
Junkie.provider = "BeeHuB"

local result = Junkie.check_key()

if not result or (not result.valid and result.message ~= "KEYLESS") then
    Junkie.get_key_link()
    return warn("Invalid key")
end

getgenv().SCRIPT_KEY = result.key or "KEYLESS"

local endpoint =
"https://bee-hu-b-core.vercel.app/api/main?key="
.. getgenv().SCRIPT_KEY ..
"&loader=BeeHuB"

loadstring(game:HttpGet(endpoint))()
