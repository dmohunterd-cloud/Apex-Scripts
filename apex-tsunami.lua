--// Rayfield UI Load
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "🌊 Tsunami Instant Steal",
    LoadingTitle = "Loading Sigma Menu...",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

--// Variables
local Flying = false
local FlySpeed = 60
local Noclip = false
local BV, BG

--// FUNCTIONS
local function StartFly()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    BV.Velocity = Vector3.zero
    BV.Parent = hrp

    BG = Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    BG.CFrame = hrp.CFrame
    BG.Parent = hrp
end

local function StopFly()
    if BV then BV:Destroy() BV = nil end
    if BG then BG:Destroy() BG = nil end
end

--// TABS
local MainTab = Window:CreateTab("⚡ Main", 4483362458)

--// INSTANT STEAL / WIN
MainTab:CreateButton({
    Name = "🚀 INSTANT STEAL (Teleport to Top/Win)",
    Callback = function()
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Teleport high above the map to hit the win zone
            char.HumanoidRootPart.CFrame = CFrame.new(0, 1000, 0)
            Rayfield:Notify({Title = "Steal Success", Content = "You reached the peak of Ohio.", Duration = 2})
        end
    end
})

--// MOVEMENT
MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        Flying = v
        if v then StartFly() else StopFly() end
    end
})

MainTab:CreateToggle({
    Name = "Noclip (Walk through walls)",
    CurrentValue = false,
    Callback = function(v) Noclip = v end
})

--// VISUALS
MainTab:CreateToggle({
    Name = "Infinite Zoom",
    CurrentValue = false,
    Callback = function(v)
        Player.CameraMaxZoomDistance = v and 100000 or 128
        Player.CameraMinZoomDistance = 0.5
    end
})

--// LOOPS
RunService.RenderStepped:Connect(function()
    local char = Player.Character
    if not char then return end

    -- Fly Logic
    if Flying and BV then
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
        BV.Velocity = moveDir * FlySpeed
    end

    -- Noclip Logic
    if Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

Rayfield:Notify({
    Title = "Script Ready",
    Content = "Fly, Noclip, and Instant Steal activated.",
    Duration = 3
})
