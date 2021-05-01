local ViewController = {}
local screens = {}

local getType = require(workspace.LightingDesk1.Desk.System.Type)

local views = script.Parent.Views

local __viewController = {}
__viewController.__index = __viewController

function ViewController.new(name, ID, scr)
	if typeof(scr) ~= "Instance" then return end
	
	local self = setmetatable({}, __viewController)
	self.__type = "viewControllerInstance"
	
	self.settings = {
		name = name,
		ID = ID,
	}
	
	self.screen = scr
	self.UI = scr.Main
	self.Dots = self.UI.Dots
	self.GUI = self.UI.GUI
	self.Selector = self.UI.Selector
	self.Highlight = self.UI.Highlight
	
	self.position = {0,0}
	self.size = {0,0}
	
	self.snapSize = {100,100}
	
	self.connections = {}
	
	self.map = {}
	
	--[[
	for x = 0, 1100, self.snapSize[1] do
		self.map[x] = {}
		
		for y = 0, 700, self.snapSize[2] do
			self.map[x][y] = self.getDotByPos({x+22,y+20})
		end
	end]]
	
	self.gui = {
		viewFrames = {},
		
		addFrame = function(id, view)
			self.gui.viewFrames[id] = view
		end,
		
		removeAllFrames = function()
			for i in pairs(self.gui.viewFrames) do
				self.gui.viewFrames[i] = nil
			end
		end,
	}
	
	self.highlighter = {
		isVisible = false,
		dragging = false,
		
		size = {0,0},
		pos = {0,0},
		
		visible = function()
			self.Highlight.GUI.Visible = true
			self.highlighter.isVisible = true
		end,
		
		invisible = function()
			self.Highlight.GUI.Visible = false
			self.highlighter.isVisible = true
		end,
		
		redrawSize = function(size)
			self.highlighter.size = size
			
			self.Highlight.GUI.Size = UDim2.fromOffset(unpack(size))
		end,
		
		redrawPos = function(pos)
			self.highlighter.pos = pos
			
			self.Highlight.GUI.Position = UDim2.fromOffset(unpack(pos))
		end,
	}
	
	self.selector = {
		isVisible = false,
		
		visible = function()
			self.Selector.Visible = true
			self.selector.isVisible = true
		end,
		
		invisible = function()
			self.Selector.Visible = false
			self.selector.isVisible = false
		end,
		
		createViewFrame = function(v, size, pos)
			local view = require(views[v]).new(size, pos, self.gui.viewFrames, #self.gui.viewFrames + 1)
			view.frame.Parent = self.GUI
			
			return view
		end,
	}
	
	self.dots = {
		transparency = 0.75,
		
		fadeIn = function()
			for i = 0.75, 0, -(0.75 / 10) do
				self.dots.transparency = i
				self.dots.update()
				wait()
			end
		end,
		
		fadeOut = function()
			for i = 0, 0.75, (0.75 / 10) do
				self.dots.transparency = i
				self.dots.update()
				wait()
			end
		end,
		
		update = function()
			for _, v in pairs(self.Dots:GetChildren()) do
				if v:IsA("TextLabel") then
					v.BackgroundTransparency = self.dots.transparency
				end
			end
		end,
	}
	
	return self
end

function __viewController:newConnection(id, connection)
	if type(id) ~= "number" or typeof(connection) ~= "RBXScriptConnection" then return end
	
	self.connections[id] = connection
end

function __viewController:getDotByPos(pos)
	for _, v in pairs(self.Dots:GetChildren()) do
		if v:IsA("TextLabel") then
			if v.AbsolutePosition == Vector2.new(pos[1],pos[2]) then
				return v
			end
		end
	end
end

function __viewController:select(view, size, pos)
	local view = self.selector.createViewFrame(view, size, pos)
	
	self.gui.addFrame(#self.gui.viewFrames + 1, view)
	
	self.size[1] = 0
	self.size[2] = 0
	
	self.position[1] = 0
	self.position[2] = 0
	
	self.selector.invisible()
	
	return view
end

function __viewController:Start()
	local success, err = pcall(function()
		local globalMinSize = {200,200}
		
		local function makeAllFramesInvisible()
			self.selector.invisible()
			self.highlighter.invisible()
		end
		
		local function setupConnections()
			local selectorButtons = self.Selector.Buttons
			
			self.newConnection(#self.connections + 1, self.Selector.topBar.Close.MouseButton1Down:Connect(function()
				self.selector.invisible()
			end))
			
			self.newConnection(#self.connections + 1, self.Highlight.MouseButton1Down:Connect(function(x, y)
				self.highlighter.visible()
				
				self.highlighter.dragging = true
				self.highlighter.redrawPos({x,y})
				
				self.position = {
					(math.ceil((x - self.GUI.AbsolutePosition.X) / self.snapSize[1]) * self.snapSize[1]),
					(math.ceil((y - self.GUI.AbsolutePosition.Y) / self.snapSize[2]) * self.snapSize[2]),
				}
			end))
			
			self.newConnection(#self.connections + 1, self.Highlight.MouseMoved:Connect(function(x, y)
				if self.highlighter.dragging then
					self.highlighter.redrawSize({x-self.highlighter.pos[1],y-self.highlighter.pos[2]})
					
					self.size = {
						(math.floor((x - self.highlighter.pos[1]) / self.snapSize[1]) * self.snapSize[1]),
						(math.floor((y - self.highlighter.pos[2]) / self.snapSize[2]) * self.snapSize[2]),
					}
					
					local colors = {
						Color3.fromRGB(0,209,255),
						Color3.fromRGB(255,127,0),
					}
						
					for x = self.position[1], 1100, 100 do
						for y = self.position[2], 700, 100 do
							local map = self.map[x][y]
								
							if x >= (self.size[1]+self.position[1]) + 100 and y >= (self.size[2]+self.position[2]) + 100 then
								map.BackgroundColor3 = colors[1]
							else
								map.BackgroundColor3 = colors[2]
							end
						end
					end
				end
			end))
			
			self.newConnection(#self.connections + 1, self.Highlight.MouseButton1Up:Connect(function(x, y)
				self.highlighter.invisible()
				self.highlighter.dragging = false
				
				self.highlighter.redrawSize({0,0})
				
				if self.size[1] >= globalMinSize[1] and self.size[2] >= globalMinSize[2] then
					self.selector.visible()
				end
			end))
			
			self.newConnection(#self.connections + 1, self.Highlight.MouseButton1Down:Connect(function(x, y)
				self.dots.fadeIn()
			end))
			
			self.newConnection(#self.connections + 1, self.Highlight.MouseButton1Up:Connect(function(x, y)
				self.dots.fadeOut()
			end))
			
			for _, v in pairs(selectorButtons:GetChildren()) do
				if v:IsA("TextButton") then
					if views[v.Name] then
						self.newConnection(#self.connections + 1, selectorButtons.Clock.MouseButton1Down:Connect(function()
							self:select(v.Name, self.size, self.position)
						end)
					end
				end
			end
		end
		
		if self.selector.isVisible or self.highlighter.isVisible then
			makeAllFramesInvisible()
		end
		setupConnections()
	end)
	
	if not success then
		print(err)
	end
end

function ViewController.getScreens()
	return screens
end

function ViewController.remove(ID)
	screens[ID] = nil
end

function ViewController.getScreenById(ID)
	return screens[ID]
end

function ViewController.getScreenByName(name)
	for _, v in pairs(screens) do
		
end

function ViewController:Start()
	local success, err = pcall(function()
		local Screens = script.Parent.Screens:GetChildren()
		
		for i = 1, #Screens do
			local v = Screens[i]
			v.Enabled = true
			screens[i] = self.new(v.Name, i, v)
			screens[i]:Start()
		end
	end)
	
	if not success then
		print(err)
	end
end

return ViewController
