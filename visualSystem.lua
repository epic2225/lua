local visualSystem = {}

visualSystem.center = workspace.CentrePart
visualSystem.screens = workspace.Screens:GetChildren()
visualSystem.panels = {}
visualSystem.pack = script.Pack:GetChildren()
visualSystem.screenLimit = 0
visualSystem.const = 50

visualSystem.gifs = {
	storage = {},
	running = {},
	
	maxFPS = 60,
}

local replicatedStorage = game:GetService("ReplicatedStorage")
local httpService = game:GetService("HttpService")
local runService = game:GetService("RunService")

function copy(inTable, outTable)
	for index, value in pairs(inTable) do
		if type(v) == "table" then
			outTable[index] = copy(value)
		else
			outTable[index] = value
		end
	end
	return outTable
end

function visualSystem:mapVisuals(screen, center)
	local d = screen.CFrame.Position - center.CFrame.Position
	for _, v in pairs(screen.g.UI:GetChildren()) do
		if v:IsA("ImageLabel" or "Frame" or "TextLabel") then
			v.Position = UDim2.new(0.5, -(d.X * self.const), 0.5, d.Y * self.const)
		elseif v:IsA("Folder") and string.match(v.Name, "SPRITE") then
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

function visualSystem.sprites.new(settings)
	local self = {}
	
	self.__type = "sprite"
	
	self.folder = settings.frames
	self.id = settings.id
	self.fps = settings.fps
	
	self.frames = {}
	
	for _, v in pairs(visualSystem:getPanels()) do
		self.frames[#self.frames + 1] = v.screens[self.folder]
	end
	
	local sprite = {sprite = self, connection = nil}
	
	if settings.alreadyRunning == true then
		visualSystem.sprites:start(sprite)
	end
	
	return self
end

function visualSystem.sprites:start(sprite)
	if not sprite then return end
	if self.storage[sprite.id] then return end
	
	self.sprites[settings.id].connection = runService.Stepped:Connect(function()
		new.x += (1 / (self.maxFPS / math.clamp(sprite.fps, 1, self.maxFPS)))
		for i = 1, #sprite.frames do
			if sprite.frames[i]:IsA("Folder") then
				local f = sprite.frames[i]:GetChildren()
				local amt = #f
				for ii = 1, amt do
					local x = (math.floor(new.x) % amt) + 1
					if x > 2 then
						f[x - 1].Visible = false
					end
					if ii == #f then
						f[amt].Visible = false
					end
					f[x].Visible = true
				end
			end
		end
	end)
	
	return new
end

function visualSystem:init(screenLimit)
	local range = #self.screens
	
	self.screenLimit = screenLimit
	
	if range <= self.screenLimit then
		self.amountOfScreens = range
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
end

return visualSystem
