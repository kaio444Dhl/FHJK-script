-- Script AutoBase + NoClip + Auto TP + Botão Teleport com condição

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- Detecta base automaticamente pelo nome
local baseCFrame = nil
for _, obj in pairs(workspace:GetChildren()) do
    if obj:IsA("Model") and (obj.Name:lower():find("diego") or obj.Name:lower():find("kaiqui")) then
        baseCFrame = obj:GetPivot()
        print("✅ Base encontrada:", obj.Name)
        break
    end
end

-- Função para criar botão
local function criarBotao(nome, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 40)
    btn.Position = pos
    btn.Text = nome
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 2
    btn.Parent = game:GetService("CoreGui")

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- NoClip toggle
local noclip = false
local btnNoClip = criarBotao("NoClip", UDim2.new(0, 20, 0, 100), function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip and char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Botão Teleport, só funciona se estiver com "Bag"
local btnTeleport = criarBotao("Teleport", UDim2.new(0, 20, 0, 150), function()
    local bag = player.Backpack:FindFirstChild("Bag") or char:FindFirstChild("Bag")
    if bag and baseCFrame and char then
        char:PivotTo(baseCFrame)
    end
end)

-- Auto TP quando pegar bag/dinheiro
task.spawn(function()
    while true do
        task.wait(1)
        if not baseCFrame then return end
        local bag = player.Backpack:FindFirstChild("Bag") or char:FindFirstChild("Bag")
        if bag then
            for i = 1, 5 do
                if char then
                    char:PivotTo(baseCFrame)
                end
                task.wait(0.2)
            end
            break
        end
    end
end)
