local Controller = script;
local Fixture = Controller.Parent;

local min = function(x, y) if x > y then return y else return x end end;
local max = function(x, z) if x < z then return z else return x end end;
local clamp = function(x, y, z) return min(max(x, y), z) end;

local Master = {
    ["Attributes"] = {
        ["Dim"] = Controller["Dim"],
        ["C"] = Controller["CC"],
        ["M"] = Controller["CM"],
        ["Y"] = Controller["CY"],
        ["Tilt"] = Controller["Tilt"],
        ["TiltSpeed"] = Controller["TiltSpeed"],
        ["FXSpeed"] = Controller["FXSpeed"],
    },
    
    ["Fixture"] = Fixture,
    
    ["UpdateDim"] = function(self)
        local L1 = self["Fixture"].Head.L1.Lens:GetChildren();
        local L2 = self["Fixture"].Head.L2.Lens:GetChildren();
        
        local Light = self["Fixture"].Head.Union.SpotLight;
        
        for ii = 1, #L1 do
            L1[ii].Transparency = 1 - clamp(self["Attributes"]["Dim"].Value, 0, 255) / 255;
        end
        
        for ii = 1, #L2 do
            L2[ii].Transparency = 1 - clamp(self["Attributes"]["Dim"].Value, 0, 255) / 255;
        end
        
        Light.Brightness = (clamp(self["Attributes"]["Dim"].Value, 0, 255) / 255) * 1.5;
    end,
    
    ["UpdateColor"] = function(self)
        local conv = function(c, m, y)
            return 255 - c, 255 - m, 255 - y
        end
        
        local L1 = self["Fixture"].Head.L1.Lens:GetChildren();
        local L2 = self["Fixture"].Head.L2.Lens:GetChildren();
        
        local Light = self.Fixture.Head.Union.SpotLight;
        
        local C = clamp(self["Attributes"]["C"].Value, 0, 255);
        local M = clamp(self["Attributes"]["M"].Value, 0, 255);
        local Y = clamp(self["Attributes"]["Y"].Value, 0, 255);
        
        for ii = 1, #L1 do
            L1[ii].Color = Color3.fromRGB(conv(C, M, Y));
        end
        
        for ii = 1, #L2 do
            L2[ii].Color = Color3.fromRGB(conv(C, M, Y));
        end
        
        Light.Color = Color3.fromRGB(conv(C, M, Y));
    end,
    
    ["UpdateTilt"] = function(self)
        self["Fixture"].Tilt.DesiredAngle = math.rad(self["Attributes"]["Tilt"].Value);
    end,
    
    ["UpdateTiltSpeed"] = function(self)
        local conv = function(x) return 0.01 * x end;
        
        self["Fixture"].Tilt.MaxVelocity = conv(self["Attributes"]["TiltSpeed"].Value);
    end,
    
    ["UpdateFXSpeed"] = function(self)
        self["Fixture"].FXSpeed.Value = self["Attributes"]["FXSpeed"].Value;
    end,
}

--Callbacks

Master["Fixture"]["Controller"]["Dim"].Changed:Connect(function() Master:UpdateDim() end)
Master["Fixture"]["Controller"]["CC"].Changed:Connect(function() Master:UpdateColor() end)
Master["Fixture"]["Controller"]["CM"].Changed:Connect(function() Master:UpdateColor() end)
Master["Fixture"]["Controller"]["CY"].Changed:Connect(function() Master:UpdateColor() end)
Master["Fixture"]["Controller"]["Tilt"].Changed:Connect(function() Master:UpdateTilt() end)
Master["Fixture"]["Controller"]["TiltSpeed"].Changed:Connect(function() Master:UpdateTiltSpeed() end)
Master["Fixture"]["Controller"]["FXSpeed"].Changed:Connect(function() Master:UpdateFXSpeed() end)
