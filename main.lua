-- Função para criar o ESP
function createESP(player)
    local ESPBox = Instance.new("BoxHandleAdornment")
    ESPBox.Size = player.Character.HumanoidRootPart.Size
    ESPBox.Adornee = player.Character.HumanoidRootPart
    ESPBox.AlwaysOnTop = true
    ESPBox.ZIndex = 10
    ESPBox.Transparency = 0.7

    -- Verifica se o jogador é um inimigo ou aliado
    if player.TeamColor == game.Players.LocalPlayer.TeamColor then
        ESPBox.Color3 = Color3.fromRGB(0, 0, 255) -- Azul para aliados
    else
        ESPBox.Color3 = Color3.fromRGB(255, 0, 0) -- Vermelho para inimigos
    end

    ESPBox.Parent = player.Character.HumanoidRootPart
end

-- Função para adicionar o ESP a todos os jogadores
function addESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createESP(player)
        end
    end
end

-- Adiciona o ESP quando novos jogadores entram no jogo
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Espera um segundo para garantir que o personagem foi carregado
        createESP(player)
    end)
end)

-- Atualiza o ESP para os jogadores existentes
addESP()

-- Atualiza o ESP quando o time do jogador mudar
game.Players.LocalPlayer:GetPropertyChangedSignal("TeamColor"):Connect(addESP)
