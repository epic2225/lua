local viewController = {}

function viewController.lerp(x, y, z)
    return (x * (1 - z)) + (y * z)
end

local debugMode = false
local debugPrint = function(...) if debugMode then print(...) end end

local int = 5

function viewController:initScreen(screen)
    local connections = {}
    local screen = screen.Main
    local selector = require(screen.SelectorMain)
    local highlight = screen.Highlight
    local size = {x = 0, y = 0}
    local position = {x = 0, y = 0}
    local dragging = false
    local diff = 100
    
    function connections.new(func)
        connections[#connections + 1] = func
    end
    
    connections.new(highlight.MouseButton1Down:Connect(function(x, y)
        local gui = highlight.GUI
        gui.Position = UDim2.fromOffset(x - screen.GUI.AbsolutePosition.X, y - screen.GUI.AbsolutePosition.Y)
        
        screen.PosX.Value = (math.ceil((x - screen.GUI.AbsolutePosition.X) / diff) * diff)
        screen.PosY.Value = (math.ceil((y - screen.GUI.AbsolutePosition.Y) / diff) * diff)
        
        dragging = true
        gui.Visible = true
    end))
    
    connections.new(highlight.MouseButton1Up:Connect(function()
        local gui = highlight.GUI
        
        if gui.AbsoluteSize.X < 100 or gui.AbsoluteSize.Y < 100 then
            selector.invisible()
            gui.Visible = false
            gui.Size = UDim2.fromOffset(0, 0)
        else
            selector.visible()
            gui.Visible = false
            gui.Size = UDim2.fromOffset(0, 0)
        end
        
        dragging = false
        
        debugPrint("RELEASED")
    end))
    
    connections.new(highlight.MouseMoved:Connect(function(x, y)
        if dragging == true then
            local gui = highlight.GUI
            
            gui.Size = UDim2.fromOffset(x - gui.AbsolutePosition.X, y - gui.AbsolutePosition.Y)
            
            size.x = (math.floor((x - gui.AbsolutePosition.X) / diff) * diff)
            size.y = (math.floor((y - gui.AbsolutePosition.Y) / diff) * diff)
            
            screen.SizeX.Value = size.x
            screen.SizeY.Value = size.y
        end
    end))
    
    connections.new(highlight.MouseButton1Down:Connect(function()
        for i = 0, 1, .1 do
            for _, v in pairs(screen.Dots:GetChildren()) do
                if v:IsA("TextLabel") then
                    v.BackgroundTransparency = self.lerp(0.75, 0, i)
                end
            end
            wait()
        end
    end))
    
    connections.new(highlight.MouseButton1Up:Connect(function()
        for i = 0, 1, .1 do
            for _, v in pairs(screen.Dots:GetChildren()) do
                if v:IsA("TextLabel") then
                    v.BackgroundTransparency = self.lerp(0.75, 0, 1 - i)
                end
            end
            wait()
        end
    end))
end

return viewController
