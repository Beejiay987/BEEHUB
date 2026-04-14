-- BeeHuB Loader Stable Build

local success, Junkie = pcall(function()
    return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
end)

if not success then
    warn("BeeHuB: Failed loading Junkie SDK")
    return
end

Junkie.service = "BeeHuB"
Junkie.identifier = "1075194"
Junkie.provider = "BeeHuB"

local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local function saveKey(key)
    if writefile then
        pcall(function()
            writefile("BeeHuB.key", key)
        end)
    end
end

local function loadKey()
    if readfile and isfile and isfile("BeeHuB.key") then
        return readfile("BeeHuB.key")
    end
end

local function loadCore(key)

    print("BeeHuB Debug: Loading core...")

    local endpoint =
        "https://bee-hu-b-core.vercel.app/api/main?key="..key

    local ok, response = pcall(function()
        return game:HttpGet(endpoint)
    end)

    if not ok then
        warn("BeeHuB: Core request failed")
        return
    end

    loadstring(response)()

end

local gui = Instance.new("ScreenGui")
gui.Name = "BeeHuBLoader"
gui.Parent = CoreGui

local blur = Instance.new("BlurEffect")
blur.Size = 15
blur.Parent = Lighting

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,420,0,250)
frame.Position = UDim2.new(.5,-210,.5,-125)
frame.BackgroundColor3 = Color3.fromRGB(28,20,44)
frame.Parent = gui

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "BeeHuB Access Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(187,134,252)
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(.8,0,0,40)
input.Position = UDim2.new(.1,0,.4,0)
input.PlaceholderText = "Enter key..."
input.Parent = frame

Instance.new("UICorner",input).CornerRadius = UDim.new(0,8)

local verify = Instance.new("TextButton")
verify.Size = UDim2.new(.8,0,0,40)
verify.Position = UDim2.new(.1,0,.65,0)
verify.Text = "Verify Key"
verify.Parent = frame

Instance.new("UICorner",verify).CornerRadius = UDim.new(0,8)

verify.MouseButton1Click:Connect(function()

    local key = input.Text:gsub("%s+","")

    if key == "" then
        warn("BeeHuB: Empty key")
        return
    end

    local result = Junkie.check_key(key)

    if result and result.valid then

        print("BeeHuB Debug: Key valid")

        saveKey(key)

        gui:Destroy()
        blur:Destroy()

        loadCore(key)

    else
        warn("BeeHuB: Invalid key")
    end

end)

local saved = loadKey()

if saved then
    local result = Junkie.check_key(saved)

    if result and result.valid then
        gui:Destroy()
        blur:Destroy()
        loadCore(saved)
    end
end
