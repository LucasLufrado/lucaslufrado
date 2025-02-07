-- Configurações
local aimbot_enabled = true
local aimbot_speed = 0.1
local aimbot_range = 100

-- Função para calcular a distância entre dois pontos
local function calculate_distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

-- Função para calcular o ângulo de mira
local function calculate_angle(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.atan2(dy, dx)
end

-- Função para mover o mouse para o alvo
local function move_mouse_to_target(x, y)
    -- Simula o movimento do mouse
    game.Players.LocalPlayer:GetMouse().Location = Vector2.new(x, y)
end

-- Função principal do aimbot
local function aimbot()
    if aimbot_enabled then
        -- Obter a posição do jogador
        local player = game.Players.LocalPlayer
        local character = player.Character
        local head = character:FindFirstChild("Head")

        if head then
            -- Obter a posição do alvo
            local targets = game.Workspace:GetDescendants()
            local closest_target = nil
            local closest_distance = aimbot_range

            for _, target in pairs(targets) do
                if target:IsA("BasePart") and target ~= head then
                    local distance = calculate_distance(head.Position.X, head.Position.Y, target.Position.X, target.Position.Y)

                    if distance < closest_distance then
                        closest_target = target
                        closest_distance = distance
                    end
                end
            end

            if closest_target then
                -- Calcular o ângulo de mira
                local angle = calculate_angle(head.Position.X, head.Position.Y, closest_target.Position.X, closest_target.Position.Y)

                -- Mover o mouse para o alvo
                move_mouse_to_target(closest_target.Position.X, closest_target.Position.Y)
            end
        end
    end
end

-- Conectar o aimbot ao clique do botão esquerdo do mouse
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        aimbot()
    end
end)