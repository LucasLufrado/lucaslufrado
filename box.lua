-- Script ESP com Linhas e Box para Roblox

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
    if humanoidRootPart then
        local color = isTeammate and Color3.new(0, 0, 1) or Color3.new(1, 0, 0)
        local line = createDrawing("Line", color)
        local box = createDrawing("Square", color)
        box.Thickness = 1
        box.Filled = false

        RunService.RenderStepped:Connect(function()
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                local screenPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                if onScreen then
                    local size = Vector2.new(50, 100)
                    line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    line.To = Vector2.new(screenPos.X, screenPos.Y)
                    line.Visible = true

                    box.Size = size
                    box.Position = Vector2.new(screenPos.X - size.X / 2, screenPos.Y - size.Y / 2)
                    box.Visible = true
                else
                    line.Visible = false
                    box.Visible = false
                end
            else
                line:Remove()
                box:Remove()
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