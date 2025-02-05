-- Script ESP com Linhas até o Inimigo para Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

function createLine(color)
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = color
    line.Transparency = 1
    line.ZIndex = 2
    return line
end

function drawESP(character, color)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local line = createLine(color)

        RunService.RenderStepped:Connect(function()
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                local screenPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                if onScreen then
                    line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    line.To = Vector2.new(screenPos.X, screenPos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line:Remove()
            end
        end)
    end
end

function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local teamColor = player.Team == localPlayer.Team and Color3.new(0, 0, 1) or Color3.new(1, 0, 0)
            if not player.Character:FindFirstChild("LineESP") then
                drawESP(player.Character, teamColor)
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
