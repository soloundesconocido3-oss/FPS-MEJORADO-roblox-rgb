-- ANTI ERROR CARGA
repeat task.wait() until game:IsLoaded()

-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Camera = workspace.CurrentCamera

-- ANTI DUPLICADO
if Player.PlayerGui:FindFirstChild("LEGNA_FPS_PRO") then
	Player.PlayerGui.LEGNA_FPS_PRO:Destroy()
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LEGNA_FPS_PRO"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- FRAME
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 165, 0, 32)
Frame.Position = UDim2.new(0.01, 0, 0.12, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke", Frame)
Stroke.Thickness = 1

local Label = Instance.new("TextLabel")
Label.Size = UDim2.fromScale(1, 1)
Label.BackgroundTransparency = 1
Label.RichText = true
Label.Font = Enum.Font.GothamBold
Label.TextSize = 14
Label.TextColor3 = Color3.new(1,1,1)
Label.Parent = Frame

-- BOTÓN BOOST
local BoostButton = Instance.new("TextButton")
BoostButton.Size = UDim2.new(0, 110, 0, 26)
BoostButton.Position = UDim2.new(0, 0, 1, 6)
BoostButton.Text = "BOOST OFF ❌"
BoostButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
BoostButton.TextColor3 = Color3.new(1,1,1)
BoostButton.Parent = Frame

local boosted = false

local function applyBoost()
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 100000
	Lighting.Brightness = 2
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	
	for _,v in ipairs(game:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = false
		end
		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
		end
	end
end

BoostButton.MouseButton1Click:Connect(function()
	boosted = not boosted
	
	if boosted then
		BoostButton.Text = "BOOST ON 🔥"
		applyBoost()
	else
		BoostButton.Text = "BOOST OFF ❌"
	end
end)

-- DRAG
local dragging, dragInput, dragStart, startPos

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		
		Frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- RGB BORDE
local hue = 0
RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.8) % 1
	Stroke.Color = Color3.fromHSV(hue,1,1)
end)

-- FPS
local Frames = 0
local FPS = 0
local SmoothFPS = 0

RunService.RenderStepped:Connect(function()
	Frames += 1
end)

task.spawn(function()
	while true do
		task.wait(1)
		FPS = Frames
		Frames = 0
	end
end)

task.spawn(function()
	while true do
		task.wait(0.2)
		SmoothFPS = math.floor((SmoothFPS * 0.8) + (FPS * 0.2))
	end
end)

-- TEXTO
RunService.RenderStepped:Connect(function()

	local Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 0)

	local PingColor = "#00FF00"
	if Ping > 80 then PingColor = "#FFFF00" end
	if Ping > 150 then PingColor = "#FFA500" end
	if Ping > 250 then PingColor = "#FF0000" end

	local Status = "STABLE"
	local StatusColor = "#00FF00"

	if SmoothFPS < 60 then
		Status = "MID"
		StatusColor = "#FFA500"
	end
	if SmoothFPS < 35 then
		Status = "LOW"
		StatusColor = "#FF0000"
	end

	Label.Text =
		'<font color="#FFFFFF">'..SmoothFPS..' FPS</font>' ..
		'<font color="#FFFFFF"> | </font>' ..
		'<font color="'..PingColor..'">'..Ping..' MS</font>' ..
		'<font color="#FFFFFF"> | </font>' ..
		'<font color="'..StatusColor..'">'..Status..'</font>'

	-- AUTO BOOST
	if SmoothFPS < 40 and not boosted then
		boosted = true
		BoostButton.Text = "AUTO BOOST 🔥"
		applyBoost()
	end
end)

-- TOGGLE HUD
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)

-- CROSSHAIR
UIS.MouseIconEnabled = false

local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 4, 0, 4)
Dot.Position = UDim2.new(0.5, 0, 0.5, 0)
Dot.AnchorPoint = Vector2.new(0.5, 0.5)
Dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
Dot.BorderSizePixel = 0
Dot.Parent = ScreenGui

Instance.new("UICorner", Dot).CornerRadius = UDim.new(1,0)

RunService.RenderStepped:Connect(function()
	local origin = Camera.CFrame.Position
	local direction = Camera.CFrame.LookVector * 1000

	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {Player.Character}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Raycast(origin, direction, params)

	if result and result.Instance then
		local char = result.Instance:FindFirstAncestorOfClass("Model")
		local plr = char and Players:GetPlayerFromCharacter(char)

		if plr and plr ~= Player then
			Dot.BackgroundColor3 = Color3.fromRGB(255,0,0)
		else
			Dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
		end
	else
		Dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end
end)
