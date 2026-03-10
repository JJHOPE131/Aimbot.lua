--// AIMBOT FOR YOUR OWN GAME (R6 + R15 HEADLOCK + MOBILE ENABLED)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local aimbotEnabled = false -- FIXED (was "ture")
local toggleKey = Enum.KeyCode.E
local enemyFolder = workspace:WaitForChild("Enemies")

---------------------------------------------------------------------
-- MOBILE BUTTON UI
---------------------------------------------------------------------
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AimbotUI"

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 160, 0, 60)
button.Position = UDim2.new(0.05, 0, 0.8, 0)
button.Text = "Aimbot OFF"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
button.TextColor3 = Color3.new(1, 1, 1)

button.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled

	if aimbotEnabled then
		button.Text = "Aimbot ON"
		button.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
	else
		button.Text = "Aimbot OFF"
		button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	end
end)

---------------------------------------------------------------------
-- PC TOGGLE KEY (OPTIONAL)
---------------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == toggleKey then
		aimbotEnabled = not aimbotEnabled -- FIXED toggle

		if aimbotEnabled then
			print("Aimbot Enabled")
			button.Text = "Aimbot ON"
			button.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
		else
			print("Aimbot Disabled")
			button.Text = "Aimbot OFF"
			button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		end
	end
end)

---------------------------------------------------------------------
-- Find closest enemy head
---------------------------------------------------------------------
local function getClosestEnemy()
	local closest = nil
	local shortestDist = math.huge

	for _, enemy in ipairs(enemyFolder:GetChildren()) do
		local head = enemy:FindFirstChild("Head")
		if head then
			local screenPos, visible = camera:WorldToViewportPoint(head.Position)
			if visible then
				local mousePos = UserInputService:GetMouseLocation()
				local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

				if dist < shortestDist then
					shortestDist = dist
					closest = head
				end
			end
		end
	end

	return closest
end

---------------------------------------------------------------------
-- Aimbot Loop
---------------------------------------------------------------------
RunService.RenderStepped:Connect(function()
	if aimbotEnabled then
		local head = getClosestEnemy()
		if head then
			camera.CFrame = camera.CFrame:Lerp(
				CFrame.new(camera.CFrame.Position, head.Position),
				0.25
			)
		end
	end
end)
