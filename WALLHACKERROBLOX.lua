local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function CreateESP(player)
    if player == LocalPlayer then return end -- Evita criar ESP para si mesmo
    
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 0, 0)
    Box.Thickness = 2
    Box.Filled = false
    
    local Line = Drawing.new("Line")
    Line.Visible = false
    Line.Color = Color3.fromRGB(255, 0, 0)
    Line.Thickness = 1
    
    local NameTag = Drawing.new("Text")
    NameTag.Visible = false
    NameTag.Color = Color3.fromRGB(255, 0, 0)
    NameTag.Size = 16
    NameTag.Center = true
    NameTag.Outline = true
    
    local function Update()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = player.Character.HumanoidRootPart
            local Head = player.Character:FindFirstChild("Head")
            local Humanoid = player.Character:FindFirstChild("Humanoid")
            if RootPart and Head and Humanoid then
                local RootPosition, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
                local HeadPosition = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0))
                local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - RootPart.Position).Magnitude
                
                if OnScreen then
                    Box.Size = Vector2.new(50, 100)
                    Box.Position = Vector2.new(RootPosition.X - 25, RootPosition.Y - 50)
                    Box.Visible = true
                    
                    Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    Line.To = Vector2.new(RootPosition.X, RootPosition.Y)
                    Line.Visible = true
                    
                    NameTag.Text = string.format("%s | %dm", player.Name, math.floor(Distance))
                    NameTag.Position = Vector2.new(HeadPosition.X, HeadPosition.Y - 15)
                    NameTag.Visible = true
                else
                    Box.Visible = false
                    Line.Visible = false
                    NameTag.Visible = false
                end
            end
        end
    end
    
    RunService.RenderStepped:Connect(Update)
end

for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end