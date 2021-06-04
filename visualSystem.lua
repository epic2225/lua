local visualSystem = {}

visualSystem.center = workspace.CentrePart
visualSystem.screens = workspace.Screens:GetChildren()
visualSystem.panels = {}
visualSystem.pack = script.Pack:GetChildren()
visualSystem.maxScreens = 500
visualSystem.const = 50

local self = {
	storage = {},
	running = {},
}

local replicatedStorage = game:GetService("ReplicatedStorage")
local httpService = game:GetService("HttpService")
local runService = game:GetService("RunService")

local runEvent = runService.Stepped

local match = string.match
local sub = string.sub

local uDim2 = UDim2.new
local vector2 = Vector2.new

local floor = math.floor

function visualSystem:mapVisuals(screen, center)
	local gui = screen.g
	
	local const = self.const
	local c0 = screen.CFrame
	local c1 = center.CFrame
	local difference = c0.Position - c1.Position
	local x, y = difference.x * const, difference.y * const
	local size = screen.Size
	local sizeX, sizeY = size.X * const, size.Y * const
	
	for _, v in pairs(gui.UI:GetChildren()) do
		if v.ClassName == "ImageLabel" or "Frame" or "TextLabel" then
			v.Position = uDim2(0.5, -y, 0.5, x)
		elseif v.ClassName == "Folder" and sub(v.Name, 1, 3) == "GIF" then
			for _, frame in pairs(v:GetChildren()) do
				if frame.ClassName == "TextLabel" or "ImageLabel" then
					frame.Position = uDim2(0.5, -x, 0.5, y)
				end
			end
		end
	end
	
	gui.CanvasSize = vector2(sizeX, sizeY)
end

function visualSystem:getPanels()
	local panels = {}
	local __panels = self.panels
	
	for k, v in pairs(__panels) do
		local panel = {screens = {}}
		panel.name = v.Name
		
		local screens = panel.screens
		
		for _, ui in pairs(v.g.UI:GetChildren()) do
			screens[ui.Name] = ui
		end
		
		panels[panel.name] = panel
	end
	
	return panels
end

function visualSystem.newGif(settings)
	local new = {
		fps = settings.fps,
		id = settings.id,
		name = settings.name,
		
		frames = {},
	}
	
	local frames = new.frames
	local id = new.id
	local amount = #frames
	
	for _, v in pairs(visualSystem:getPanels()) do
		frames[#frames + 1] = v.screens[frames]
	end
	
	new.run = function()
		local x = 0
		local fps = new.fps
		
		self.running[id] = {new, runEvent:Connect(function()
			x += 1 / (60 / fps)
			for i = 1, amount do
				local f = frames[i]
				if f.ClassName == "Folder" then
					local v = f:GetChildren()
					local amt = #v
					for ii = 1, amt do
						local __x = (floor(x) % amt) + 1
						if __x > 2 then
							v[__x - 1].Visible = false
						end
						if ii == amt then
							v[amt].Visible = false
						end
						v[__x].Visible = true
					end
				end
			end
		end)}
	end
	
	new.stop = function()
		self.running[id][2] = nil
	end
	
	return new
end

function visualSystem.runGif(id)
	local running = self.running
	local storage = self.storage
	
	if not running[id] then
		local stored = storage[id]
		if stored then
			running[id] = stored
		end
	end
end

function visualSystem.pauseGif(id)
	local running = self.running
	local storage = self.storage
	
	local gif = running[id]
	
	if gif then
		gif[2].stop()
		
		if storage[id] then
			running[id] = nil
		end
	end
end

function visualSystem:init()
	local screens = self.screens
	local panels = self.panels
	local maxScreens = self.maxScreens
	local pack = self.pack
	local center = self.center
	local range, pRange = #screens, #pack
	
	if range <= maxScreens then
		for i = 1, range do
			panels[i] = screens[i]
			
			local panel = panels[i]
			local UI = panel.g.UI
			
			for ii = 1, pRange do
				local new = pack[ii]:Clone()
				new.Parent = UI
			end
		end
		
		wait()
		
		for _, v in pairs(panels) do
			self:mapVisuals(v, center)
		end
	end
	
	self.amountOfScreens = range
end

return visualSystem
