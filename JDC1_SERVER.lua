--[[













// Title: FixtureHandler2
// Author: cfgtsp
// Date Edited: 11/01/21















]]

local Control = script

local Effects = workspace.Effects2
local Fixture = workspace.JDC1:GetChildren()

local function clamp(x, y, z) return math.min(math.max(x, y), z) end

local function reverseBool(bool)
    local reverse = {
        [false] = true,
        [true] = false,
    }
    
    return reverse[bool];
end

local Master = {
    UpdateFX = function(self, selectedEffect, boolean)
        Effects[selectedEffect].Disabled = reverseBool(boolean);
    end,
    
    UpdateCMY = function(self, c, m, y)
        for i = 1, #Fixture do
            for ii = 1, #Fixture[i]:GetChildren() do
                Fixture[i]:GetChildren()[ii].Controller.CC.Value = c;
                Fixture[i]:GetChildren()[ii].Controller.CM.Value = m;
                Fixture[i]:GetChildren()[ii].Controller.CY.Value = y;
            end
        end
    end,
    
    UpdateDim = function(self, dim)
        for i = 1, #Fixture do
            for ii = 1, #Fixture[i]:GetChildren() do
                Fixture[i]:GetChildren()[ii].Controller.Dim.Value = clamp(dim, 0, 255);
            end
        end
    end,
    
    UpdateTilt = function(self, ang)
        for i = 1, #Fixture do
            for ii = 1, #Fixture[i]:GetChildren() do
                Fixture[i]:GetChildren()[ii].Controller.Tilt.Value = clamp(ang, -180, 180);
            end
        end
    end,
    
    UpdateFXSpeed = function(self, spd)
        Effects["Speed"].Value = clamp(spd, 0, 30);
    end,
}

Master:UpdateDim(0)
Master:UpdateCMY(0, 0, 0)

--Callbacks

Control.Dim.OnServerEvent:Connect(function(playerName, dim) Master:UpdateDim(dim) end)
Control.SetCMY.OnServerEvent:Connect(function(playerName, c, m, y) Master:UpdateCMY(c, m, y) end)
Control.Tilt.OnServerEvent:Connect(function(playerName, ang) Master:UpdateTilt(ang) end)
Control.FXSpeed.OnServerEvent:Connect(function(playerName, spd) Master:UpdateFXSpeed(spd) end)
Control.T1.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("Tilt1", bool) end)
Control.T2.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("Tilt2", bool) end)
Control.C1.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("ColorFade1", bool) end)
Control.C2.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("ColorFade2", bool) end)
Control.C3.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("ColorFade3", bool) end)
Control.TR1.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("Trans", bool) end)
Control.TR2.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("Trans2", bool) end)
Control.TR3.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("Trans3", bool) end)
Control.TR4.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("Trans4", bool) end)
Control.TR5.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("Trans5", bool) end)
Control.Rand.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("Rand", bool) end)
Control.Strobe.OnServerEvent:Connect(function(playerName, bool) Master:UpdateFX("Strobe", bool) end)
