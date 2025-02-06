local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local function createESP(player)
    if player == localPlayer then return end
    
    local line = Drawing.new("Line")
    local box = Drawing.new("Square")
    local text = Drawing.new("Text")
    
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Thickness = 2
    
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 1
    box.Filled = false
    
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Size = 16
    text.Center = true
    text.Outline = true
    
    local function update()
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPosition, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local distance = (localPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                
                line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                line.To = Vector2.new(screenPosition.X, screenPosition.Y)
                line.Visible = true
                
                box.Size = Vector2.new(50, 100)
                box.Position = Vector2.new(screenPosition.X - 25, screenPosition.Y - 50)
                box.Visible = true
                
                text.Text = string.format("%s (%.1fm)", player.Name, distance)
                text.Position = Vector2.new(screenPosition.X, screenPosition.Y - 60)
                text.Visible = true
            else
                line.Visible = false
                box.Visible = false
                text.Visible = false
            end
        else
            line.Visible = false
            box.Visible = false
            text.Visible = false
        end
    end
    
    runService.RenderStepped:Connect(update)
end

for _, player in pairs(players:GetPlayers()) do
    createESP(player)
end

players.PlayerAdded:Connect(function(player)
    createESP(player)
end)