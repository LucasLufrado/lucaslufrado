local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- Função para criar um ESP para um jogador
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head
    billboard.Size = UDim2.new(4, 0, 1, 0)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    
    billboard.Parent = game.CoreGui
    
    local line = Drawing.new("Line")
    local box = Drawing.new("Square")
    
    RunService.RenderStepped:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local rootPos = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                textLabel.Text = string.format("%s\n%.1f m", player.Name, distance)
                
                local color = (player.Team == LocalPlayer.Team) and Color3.new(0, 0, 1) or Color3.new(1, 0, 0)
                textLabel.TextColor3 = color
                
                -- Configurando a linha
                line.Visible = true
                line.Color = color
                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                line.To = Vector2.new(rootPos.X, rootPos.Y)
                
                -- Configurando a caixa
                box.Visible = true
                box.Color = color
                box.Position = Vector2.new(rootPos.X - 25, rootPos.Y - 50)
                box.Size = Vector2.new(50, 100)
            else
                textLabel.Text = ""
                line.Visible = false
                box.Visible = false
            end
        else
            billboard:Destroy()
            line:Remove()
            box:Remove()
        end
    end)
end

-- Adicionar ESP para todos os jogadores
for _, player in ipairs(Players:GetPlayers()) do
    CreateESP(player)
end

-- Adicionar ESP para novos jogadores que entrarem
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        CreateESP(player)
    end)
end)