local visualSystem = {}

visualSystem.center = workspace.CentrePart
visualSystem.screens = workspace.Screens:GetChildren()
visualSystem.panels = {}
visualSystem.pack = script.Pack:GetChildren()
visualSystem.maxScreens = 500
visualSystem.const = 50

visualSystem.gifs = {
	storage = {},
	running = {},
	
	maxFPS = 60,
}

local replicatedStorage = game:GetService("ReplicatedStorage")
local httpService = game:GetService("HttpService")
local runService = game:GetService("RunService")

function visualSystem:mapVisuals(screen, center)
	local d = screen.CFrame.Position - center.CFrame.Position
	for _, v in pairs(screen.g.UI:GetChildren()) do
		if v:IsA("ImageLabel" or "Frame" or "TextLabel") then
			v.Position = UDim2.new(0.5, -(d.X * self.const), 0.5, d.Y * self.const)
		elseif v:IsA("Folder") and string.match(v.Name, "GIF") then
			for _, frame in pairs(v:GetChildren()) do
				if frame:IsA("TextLabel" or "ImageLabel") then
					frame.Position = UDim2.new(0.5, -(d.X * self.const), 0.5, d.Y * self.const)
				end
			end
		end
	end
	screen.g.CanvasSize = Vector2.new(screen.Size.X * self.const, screen.Size.Y * self.const)
end

function visualSystem:getPanels()
	local panels = {}
	for k, v in pairs(self.panels) do
		local panel = {name = nil, screens = {}}
		for _, ui in pairs(v.g.UI:GetChildren()) do
			panel.name = k
			panel.screens[ui.name] = ui
		end
		panels[panel.name] = panel
	end
	return panels
end

function visualSystem.gifs:startGif(settings)
	if self.running[settings.id] then return end
	
	local new = {
		fps = settings.fps,
		id = settings.id,
		name = settings.name,
		guid = httpService:GenerateGUID(false),
		
		x = 0,
	}
	
	new.frames = {}
	
	for _, v in pairs(visualSystem:getPanels()) do
		new.frames[#new.frames + 1] = v.screens[settings.frames]
	end
	
	self.running[settings.id] = {settings = new, connection = runService.Stepped:Connect(function()
		new.x += (1 / (self.maxFPS / settings.fps))
		for i = 1, #new.frames do
			if new.frames[i]:IsA("Folder") then
				local f = new.frames[i]
				for ii = 1, #f:GetChildren() do
					local x = (math.floor(new.x) % (#f:GetChildren())) + 1
					if x > 2 then
						f:GetChildren()[x - 1].Visible = false
					end
					if ii == #f:GetChildren() then
						f:GetChildren()[#f:GetChildren()].Visible = false
					end
					f:GetChildren()[x].Visible = true
				end
			end
		end
	end)}
	
	return new
end

function visualSystem:init()
    local range = #self.screens
	if range <= self.maxScreens then
		for i = 1, range do
			self.panels[i] = self.screens[i]
			for ii = 1, #self.pack do
				local new = self.pack[ii]:Clone()
				new.Parent = self.panels[i].g.UI
			end
		end
		wait()
		for _, v in pairs(self.panels) do
			self:mapVisuals(v, self.center)
		end
	end
	self.amountOfScreens = range
end

return visualSystem
