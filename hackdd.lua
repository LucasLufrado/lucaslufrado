local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")

function createESP(player)
    if player == localPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(1, 0, 0)
    highlight.FillColor = Color3.new(1, 0, 0)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = player.Character:FindFirstChild("Head")
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 0, 0)
    textLabel.TextScaled = true
    textLabel.Text = player.Name
    textLabel.Parent = billboard
    
    runService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local distance = (localPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
            textLabel.Text = player.Name .. " [" .. math.floor(distance) .. "m]"
        end
    end)
end

for _, player in ipairs(players:GetPlayers()) do
    if player ~= localPlayer then
        createESP(player)
    end
end