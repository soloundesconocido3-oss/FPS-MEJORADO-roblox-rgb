-- 🔥 ESPERA CARGA
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- 💀 ANTI DUPLICADO
if Player.PlayerGui:FindFirstChild("LEGNA_FPS_PRO") then
	Player.PlayerGui.LEGNA_FPS_PRO:Destroy()
end

-- 🎨 GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LEGNA_FPS_PRO"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 170, 0, 60)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
Frame.BackgroundTransparency = 0.2
Frame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Parent = Frame

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, 0, 0.5, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: 0"
FPSLabel.TextColor3 = Color3.new(1,1,1)
FPSLabel.Font = Enum.Font.SourceSansBold
FPSLabel.TextScaled = true
FPSLabel.Parent = Frame

local PingLabel = Instance.new("TextLabel")
PingLabel.Position = UDim2.new(0,0,0.5,0)
PingLabel.Size = UDim2.new(1, 0, 0.5, 0)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "Ping: 0"
PingLabel.TextColor3 = Color3.new(1,1,1)
PingLabel.Font = Enum.Font.SourceSansBold
PingLabel.TextScaled = true
PingLabel.Parent = Frame

-- 🌈 RGB
local hue = 0
RunService.RenderStepped:Connect(function()
	hue = (hue + 0.005) % 1
	UIStroke.Color = Color3.fromHSV(hue,1,1)
end)

-- 📊 FPS
RunService.RenderStepped:Connect(function(dt)
	local fps = math.floor(1/dt)
	FPSLabel.Text = "FPS: "..fps
end)

-- 📶 PING
RunService.RenderStepped:Connect(function()
	local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
	PingLabel.Text = "Ping: "..ping

	if ping >= 200 and ping <= 600 then
		PingLabel.TextColor3 = Color3.fromRGB(255,165,0)
	elseif ping > 600 then
		PingLabel.TextColor3 = Color3.fromRGB(255,0,0)
	else
		PingLabel.TextColor3 = Color3.fromRGB(255,255,255)
	end
end)

-- ⚡ BOOST FPS
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
settings().Rendering.QualityLevel = "Level01"

for _,v in pairs(workspace:GetDescendants()) do
	if v:IsA("BasePart") then
		v.Material = Enum.Material.Plastic
		v.Reflectance = 0
	elseif v:IsA("Decal") or v:IsA("Texture") then
		v:Destroy()
	end
end

-- 🎯 OCULTAR CURSOR
pcall(function()
	UIS.MouseIconEnabled = false
end)

-- 🎯 CROSSHAIR PRO
local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0,2,0,2)
Dot.AnchorPoint = Vector2.new(0.5, 0.5)
Dot.Position = UDim2.new(0.5, 0, 0.47, 0) -- AJUSTA SI QUIERES
Dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
Dot.BorderSizePixel = 0
Dot.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1,0)
Corner.Parent = Dot

-- 🎥 ESTABILIZADOR PRO (SUAVE Y SEGURO)
local camera = workspace.CurrentCamera
local smoothness = 0.15 -- puedes bajar a 0.1 si quieres más suave

local lastCF = camera.CFrame

RunService.RenderStepped:Connect(function()
	if camera then
		lastCF = lastCF:Lerp(camera.CFrame, smoothness)
		camera.CFrame = lastCF
	end
end)
