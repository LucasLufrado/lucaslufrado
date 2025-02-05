-- Script ESP para Roblox

local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local players = game.Players:GetPlayers()
local esp = {}

-- Função para desenhar a linha até o inimigo ou aliado
local function drawLine(startPos, endPos, color)
    local line = Instance.new("Part")
    line.Anchored = true
    line.CanCollide = false
    line.Size = Vector3.new(0.1, 0.1, (startPos - endPos).Magnitude)
    line.Position = (startPos + endPos) / 2
    line.BrickColor = BrickColor.new(color)
    line.Orientation = (endPos - startPos).unit:Cross(Vector3.new(0, 1, 0)).unit
    line.Parent = game.Workspace
    return line
end

-- Função para criar um Box (caixa) em torno do jogador
local function createBox(character)
    local box = Instance.new("BillboardGui")
    box.Adornee = character
    box.Size = UDim2.new(0, 150, 0, 50)
    box.StudsOffset = Vector3.new(0, 2, 0)
    box.Parent = character

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = character.Name
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.Parent = box
end

-- Função para desenhar o esqueleto
local function drawSkeleton(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("Part") and part.Name ~= "Head" then
            local marker = Instance.new("Part")
            marker.Size = Vector3.new(0.2, 0.2, 0.2)
            marker.Shape = Enum.PartType.Ball
            marker.Position = part.Position
            marker.Anchored = true
            marker.CanCollide = false
            marker.Color = Color3.fromRGB(255, 255, 255)
            marker.Parent = game.Workspace
        end
    end
end

-- Função para calcular a distância entre o jogador e o alvo
local function getDistance(startPos, endPos)
    return (startPos - endPos).Magnitude
end

-- Função principal que roda no ciclo de atualização
local function updateESP()
    for _, target in pairs(players) do
        if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local character = target.Character
            local rootPart = character:WaitForChild("HumanoidRootPart")
            local screenPos = camera:WorldToScreenPoint(rootPart.Position)

            -- Calcular a distância
            local dist = getDistance(player.Character.HumanoidRootPart.Position, rootPart.Position)
            local color = target.Team == player.Team and "Bright blue" or "Bright red"

            -- Criar a linha até o inimigo ou aliado
            drawLine(player.Character.HumanoidRootPart.Position, rootPart.Position, color)

            -- Criar o Box e o nome
            createBox(character)

            -- Desenhar o esqueleto
            drawSkeleton(character)

            -- Exibir a distância
            local distanceLabel = Instance.new("BillboardGui")
            distanceLabel.Adornee = character
            distanceLabel.Size = UDim2.new(0, 100, 0, 50)
            distanceLabel.StudsOffset = Vector3.new(0, 3, 0)
            distanceLabel.Parent = character
            local distanceText = Instance.new("TextLabel")
            distanceText.Text = string.format("%.1f m", dist)
            distanceText.Size = UDim2.new(1, 0, 1, 0)
            distanceText.BackgroundTransparency = 1
            distanceText.TextColor3 = Color3.new(1, 0, 0)
            distanceText.Parent = distanceLabel
        end
    end
end

-- Loop principal
while true do
    wait(0.1)
    updateESP()
end