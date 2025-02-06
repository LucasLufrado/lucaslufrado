local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

local function CreateESP(Player)
    if Player == LocalPlayer then return end
    
    local Character = Player.Character
    if not Character then return end
    
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return end
    
    -- Criar Billboard para Nome
    local Billboard = Instance.new("BillboardGui")
    Billboard.Adornee = HumanoidRootPart
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 2, 0)
    Billboard.AlwaysOnTop = true
    
    local NameLabel = Instance.new("TextLabel", Billboard)
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = Player.Name
    NameLabel.TextColor3 = Color3.new(1, 0, 0) -- Vermelho para inimigos
    NameLabel.TextStrokeTransparency = 0.5
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextSize = 16
    
    -- Criar Box (quadro transparente)
    local Box = Instance.new("BoxHandleAdornment")
    Box.Adornee = HumanoidRootPart
    Box.Size = Vector3.new(4, 6, 0)
    Box.Color3 = Color3.new(1, 0, 0) -- Vermelho para inimigos
    Box.Transparency = 0.5
    Box.ZIndex = 0
    Box.AlwaysOnTop = true
    
    -- Criar Linha (linha até o jogador)
    local Line = Drawing.new("Line")
    Line.Thickness = 2
    Line.Color = Color3.new(1, 0, 0) -- Vermelho para inimigos
    
    Billboard.Parent = Character
    Box.Parent = Character
    
    RunService.RenderStepped:Connect(function()
        if Character and HumanoidRootPart then
            local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
            if OnScreen then
                local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                NameLabel.Text = string.format("%s [%d]", Player.Name, Distance)
                Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Line.To = Vector2.new(ScreenPosition.X, ScreenPosition.Y)
                Line.Visible = true
            else
                Line.Visible = false
            end
        else
            Line.Visible = false
        end
    end)
end

-- Detectar novos jogadores (Inimigos)
for _, Player in pairs(Players:GetPlayers()) do
    if Player.Team ~= LocalPlayer.Team then
        CreateESP(Player)
    end
end

Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function()
        if Player.Team ~= LocalPlayer.Team then
            CreateESP(Player)
        end
    end)
end)