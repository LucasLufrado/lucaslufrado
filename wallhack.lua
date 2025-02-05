-- Script ESP completo com Linhas, Box, Distância e Nome para Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

function createDrawing(type, color)
    local drawing = Drawing.new(type)
    drawing.Color = color
    drawing.Transparency = 1
    drawing.Thickness = 2
    drawing.ZIndex = 2
    return drawing
end

function drawESP(character, isTeammate)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")

    if humanoidRootPart and head then
        local color = isTeammate and Color3.new(0, 0, 1) or Color3.new(1, 0, 0)
        local line = createDrawing("Line", color)
        local box = createDrawing("Square", color)
        local nameTag = createDrawing("Text", color)
        local distanceTag = createDrawing("Text", color)

        box.Thickness = 1
        box.Filled = false

        nameTag.Size = 14
        nameTag.Center = true
        nameTag.Outline = true

        distanceTag.Size = 14
        distanceTag.Center = true
        distanceTag.Outline = true

        RunService.RenderStepped:Connect(function()
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                local screenPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                local headPos, headOnScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen and headOnScreen then
                    local distance = (camera.CFrame.Position - humanoidRootPart.Position).Magnitude
                    
                    -- Linha
                    line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    line.To = Vector2.new(screenPos.X, screenPos.Y)
                    line.Visible = true

                    -- Caixa (Box)
                    local size = Vector2.new(50, 100)
                    box.Size = size
                    box.Position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                    box.Visible = true

                    -- Nome do jogador
                    nameTag.Text = character.Name
                    nameTag.Position = Vector2.new(headPos.X, headPos.Y - 20)
                    nameTag.Visible = true

                    -- Distância em metros
                    distanceTag.Text = string.format("%.0f m", distance)
                    distanceTag.Position = Vector2.new(screenPos.X, screenPos.Y + 60)
                    distanceTag.Visible = true
                else
                    line.Visible = false
                    box.Visible = false
                    nameTag.Visible = false
                    distanceTag.Visible = false
                end
            else
                line:Remove()
                box:Remove()
                nameTag:Remove()
                distanceTag:Remove()
            end
        end)
    end
end

function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local isTeammate = player.Team == localPlayer.Team
            if not player.Character:FindFirstChild("ESP") then
                drawESP(player.Character, isTeammate)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart")
        updateESP()
    end)
end)

-- Atualiza o ESP periodicamente
task.spawn(function()
    while true do
        updateESP()
        task.wait(2)
    end
end)