-- BeeHuB Loader (Amethyst Secure Edition)

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()

Junkie.service = "BeeHuB"
Junkie.identifier = "1075194"
Junkie.provider = "BeeHuB"

-- =========================
-- 🎨 BeeHuB Amethyst Theme
-- =========================

local Colors = {
    background = Color3.fromRGB(18,12,28),
    surface = Color3.fromRGB(28,20,44),
    surfaceLight = Color3.fromRGB(40,28,60),

    primary = Color3.fromRGB(187,134,252),
    primaryDark = Color3.fromRGB(150,95,220),
    primaryGlow = Color3.fromRGB(210,170,255),

    accent = Color3.fromRGB(255,196,77),

    success = Color3.fromRGB(120,255,190),
    successDark = Color3.fromRGB(90,220,160),
    successGlow = Color3.fromRGB(170,255,210),

    error = Color3.fromRGB(255,95,120),

    textPrimary = Color3.fromRGB(245,240,255),
    textSecondary = Color3.fromRGB(190,175,210),
    textMuted = Color3.fromRGB(150,135,170),

    border = Color3.fromRGB(70,50,100),
    borderLight = Color3.fromRGB(110,80,160),

    neonPurple = Color3.fromRGB(220,170,255)
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- =========================
-- 💾 Save Key Support
-- =========================

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

-- =========================
-- 🐝 UI Builder
-- =========================

local function createUI()

    local gui = Instance.new("ScreenGui")
    gui.Name = "BeeHuBLoader"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = game.CoreGui

    local blur = Instance.new("BlurEffect")
    blur.Size = 16
    blur.Parent = Lighting

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,420,0,260)
    frame.Position = UDim2.new(.5,-210,.5,-130)
    frame.BackgroundColor3 = Colors.surface
    frame.Parent = gui

    Instance.new("UICorner",frame).CornerRadius = UDim.new(0,14)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,50)
    title.BackgroundTransparency = 1
    title.Text = "BeeHuB Access Panel"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Colors.primaryGlow
    title.Parent = frame

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1,0,0,30)
    subtitle.Position = UDim2.new(0,0,0,40)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Amethyst Secure Loader"
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextColor3 = Colors.textSecondary
    subtitle.Parent = frame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(.8,0,0,40)
    input.Position = UDim2.new(.1,0,.4,0)
    input.PlaceholderText = "Enter BeeHuB key..."
    input.BackgroundColor3 = Colors.surfaceLight
    input.TextColor3 = Colors.textPrimary
    input.Parent = frame

    Instance.new("UICorner",input).CornerRadius = UDim.new(0,8)

    local verify = Instance.new("TextButton")
    verify.Size = UDim2.new(.8,0,0,40)
    verify.Position = UDim2.new(.1,0,.65,0)
    verify.Text = "Verify Key"
    verify.Font = Enum.Font.GothamBold
    verify.TextSize = 15
    verify.BackgroundColor3 = Colors.primary
    verify.TextColor3 = Color3.new(1,1,1)
    verify.Parent = frame

    Instance.new("UICorner",verify).CornerRadius = UDim.new(0,8)

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1,0,0,20)
    status.Position = UDim2.new(0,0,.85,0)
    status.BackgroundTransparency = 1
    status.TextColor3 = Colors.textSecondary
    status.Text = ""
    status.TextSize = 13
    status.Parent = frame

    return gui,input,verify,status,blur
end

-- =========================
-- 🔐 Verify Key
-- =========================

local gui,input,verify,status,blur = createUI()

local function startCore(key)

    getgenv().SCRIPT_KEY = key

    print("BeeHuB Debug: Key verified")

    local endpoint =
        "https://bee-hu-b-core.vercel.app/api/main?key="..key

    local ok,response = pcall(function()
        return game:HttpGet(endpoint)
    end)

    if ok then
        print("BeeHuB Debug: Core loaded")
        loadstring(response)()
    else
        warn("BeeHuB Debug: Failed loading core")
    end

end

-- =========================
-- 🔑 Button Logic
-- =========================

verify.MouseButton1Click:Connect(function()

    local key = input.Text:gsub("%s+","")

    if key == "" then
        status.Text = "Enter key first"
        status.TextColor3 = Colors.error
        return
    end

    status.Text = "Verifying..."
    status.TextColor3 = Colors.primaryGlow

    local result = Junkie.check_key(key)

    if result and result.valid then

        saveKey(key)

        status.Text = "Access granted ✓"
        status.TextColor3 = Colors.success

        task.wait(1)

        gui:Destroy()
        blur:Destroy()

        startCore(key)

    else

        status.Text = "Invalid key"
        status.TextColor3 = Colors.error

    end

end)

-- =========================
-- 💾 Auto Login Saved Key
-- =========================

local saved = loadKey()

if saved then

    local result = Junkie.check_key(saved)

    if result and result.valid then

        gui:Destroy()
        blur:Destroy()

        startCore(saved)

    end
end
