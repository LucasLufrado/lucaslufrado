local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local espEnabled = true

-- Tabela para armazenar os desenhos ESP
local espObjects = {}

-- Função para criar ESP para um jogador
local function createESP(player)
    if player == localPlayer then return end  -- Evita desenhar ESP no próprio jogador

    local espBox = Drawing.new("Square")
    espBox.Thickness = 2
    espBox.Color = Color3.fromRGB(255, 0, 0)
    espBox.Filled = false
    espBox.Visible = false

    local nameTag = Drawing.new("Text")
    nameTag.Size = 16
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Outline = true
    nameTag.Visible = false

    local distanceTag = Drawing.new("Text")
    distanceTag.Size = 14
    distanceTag.Color = Color3.fromRGB(0, 255, 0)
    distanceTag.Outline = true
    distanceTag.Visible = false

    espObjects[player] = {box = espBox, name = nameTag, distance = distanceTag}
end

-- Função para atualizar o ESP dos jogadores
local function updateESP()
    if not espEnabled then return end

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if rootPart and humanoid and espObjects[player] then
                local screenPosition, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                local distance = (localPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                local size = math.clamp(3000 / distance, 30, 150) -- Ajusta tamanho da caixa com base na distância

                local espBox = espObjects[player].box
                local nameTag = espObjects[player].name
                local distanceTag = espObjects[player].distance

                if onScreen then
                    espBox.Size = Vector2.new(size, size * 1.5)
                    espBox.Position = Vector2.new(screenPosition.X - size / 2, screenPosition.Y - size * 1.5 / 2)
                    espBox.Visible = true

                    nameTag.Position = Vector2.new(screenPosition.X, screenPosition.Y - size)
                    nameTag.Text = player.Name
                    nameTag.Visible = true

                    distanceTag.Position = Vector2.new(screenPosition.X, screenPosition.Y + size / 2)
                    distanceTag.Text = string.format("%.1f metros", distance)
                    distanceTag.Visible = true
                else
                    espBox.Visible = false
                    nameTag.Visible = false
                    distanceTag.Visible = false
                end
            end
        end
    end
end

-- Criar ESP para jogadores já existentes
for _, player in pairs(players:GetPlayers()) do
    createESP(player)
end