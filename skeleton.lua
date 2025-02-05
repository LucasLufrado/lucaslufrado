-- Script ESP Skeleton para Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

function createLine(parent, color)
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = color
    line.Transparency = 1
    line.ZIndex = 2
    return line
end

function drawSkeleton(character, color)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    local leftArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm")
    local rightArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")
    local leftLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
    local rightLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")

    if humanoidRootPart and head and torso and leftArm and rightArm and leftLeg and rightLeg then
        local lines = {
            createLine(character, color), -- Head to Torso
            createLine(character, color), -- Torso to Left Arm
            createLine(character, color), -- Torso to Right Arm
            createLine(character, color), -- Torso to Left Leg
            createLine(character, color), -- Torso to Right Leg
        }

        RunService.RenderStepped:Connect(function()
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                lines[1].From = camera:WorldToViewportPoint(head.Position)
                lines[1].To = camera:WorldToViewportPoint(torso.Position)

                lines[2].From = camera:WorldToViewportPoint(torso.Position)
                lines[2].To = camera:WorldToViewportPoint(leftArm.Position)

                lines[3].From = camera:WorldToViewportPoint(torso.Position)
                lines[3].To = camera:WorldToViewportPoint(rightArm.Position)

                lines[4].From = camera:WorldToViewportPoint(torso.Position)
                lines[4].To = camera:WorldToViewportPoint(leftLeg.Position)

                lines[5].From = camera:WorldToViewportPoint(torso.Position)
                lines[5].To = camera:WorldToViewportPoint(rightLeg.Position)
            else
                for _, line in ipairs(lines) do
                    line:Remove()
                end
            end
        end)
    end
end

function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local teamColor = player.Team == localPlayer.Team and Color3.new(0, 0, 1) or Color3.new(1, 0, 0)
            if not player.Character:FindFirstChild("SkeletonESP") then
                drawSkeleton(player.Character, teamColor)
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
