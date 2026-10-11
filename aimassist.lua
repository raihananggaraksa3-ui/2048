local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local enabled = false

local gui = Instance.new("ScreenGui")
gui.Name = "AimAssistUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.fromOffset(140, 45)
button.Position = UDim2.new(1, -155, 0, 100)
button.Text = "AIM: OFF"
button.TextSize = 18
button.Parent = gui

button.Activated:Connect(function()
    enabled = not enabled
    button.Text = enabled and "AIM: ON" or "AIM: OFF"
end)

RunService.RenderStepped:Connect(function()
    if not enabled then return end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local nearest, shortest = nil, 100

    for _, model in ipairs(workspace:GetChildren()) do
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        local target = model:FindFirstChild("HumanoidRootPart")

        if humanoid and target
            and model ~= character
            and not Players:GetPlayerFromCharacter(model)
            and humanoid.Health > 0 then

            local distance = (target.Position - root.Position).Magnitude

            if distance < shortest then
                nearest = target
                shortest = distance
            end
        end
    end

    if nearest then
        camera.CFrame = CFrame.lookAt(
            camera.CFrame.Position,
            nearest.Position
        )
    end
end)
