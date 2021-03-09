--[[



CPS FIXTURE MODULE





SCRIPTED BY CFGTSP



Setup:

1. Place this module in ReplicatedStorage.
2. Edit your settings if you need to.
3. Make sure the fixtures are in workspace ONLY, and there is 8 groups in them. Also ensure that the fixture file is 
   named: "CLPakyScenius".
4. To control the fixtures, use a Script or LocalScript and use require() to get this module.
5. The module should run correctly, if it doesnt, contact me at cfgtsp#9234



]]

local CPS = {
    Settings = {
        FixturesEnabled = true; --Set to false to completely disable all fixture controllers
        FixturesUpdating = true; --Set to false to stop updating the attributes of the fixtures
    };
    
    Fixtures = workspace.CLPakyScenius;
    Effects = workspace.Effects;

    Attributes = {
        Intensity = {default=0,min=0,max=255,main="Intensity"},
        R = {default=255,min=0,max=255,main="R"},
        G = {default=255,min=0,max=255,main="G"},
        B = {default=255,min=0,max=255,main="B"},
        Zoom = {default=200,min=0,max=255,main="Zoom"},
        Pan = {default=0,min=-180,max=180,main="Pan"},
        Tilt = {default=0,min=-180,max=180},main="Tilt",
        Speed = {default=127,min=0,max=255,main="Speed"},
    };
    
    FX = {
        Sine = {
            Circle1 = {
                SizeX = 45; --Default: 45
                SizeY = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Circle2 = {
                SizeX = 45; --Default: 45
                SizeY = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Circle3 = {
                SizeX = 45; --Default: 45
                SizeY = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Circle4 = {
                SizeX = 45; --Default: 45
                SizeY = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Circle5 = {
                SizeX = 45; --Default: 45
                SizeY = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Circle6 = {
                SizeX = 45; --Default: 45
                SizeY = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Tilt1 = {
                Size = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Tilt2 = {
                Size = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Tilt3 = {
                Size = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Tilt4 = {
                Size = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Tilt5 = {
                Size = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Tilt6 = {
                Size = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Zoom1 = {
                Size = 45; --Default: 45
                Speed = 3; --Default: 3
            };
            
            Color1 = {
                Speed = 3; --Default: 3
            };
            
            Color2 = {
                Speed = 3; --Default: 3
            };
            
            Color3 = {
                Speed = 3; --Default: 3
            };
        }
    };

    Groups = {
        "G1",
        "G2",
        "G3",
        "G4",
        "G5",
        "G6",
        "G7",
        "G8",
    };

    updaters = {}
}

--Functions

local debugMode = false

local dPrint = function(...) if (debugMode) then print(...) end end

local reverse = function(bool)
    return ({
        [true] = false;
        [false] = true;
    })[bool]
end

function CPS:FindEffect(effectIndex, subIndex)
    return self:FindEffect(effectIndex)[subIndex]
end

function CPS:UpdateEffect(i, ii, bool)
    self.FX[i][ii].enabled = bool
    self.Effects[i][ii].Disabled = reverse(bool);
end

function CPS:ChangeEffectSpeed(index1, index2, spd)
    if not self.Effects[index1][index2].enabled 
end

function CPS:UpdateFixtures(group, attribute, value)
    if self.Settings.FixturesUpdating then
        local att = self.Attributes[attribute]

        self.updaters[group](att, value)
    end
end

function CPS:GetFixtures()
    local fixtures = {}
    local f = self.Fixtures:GetChildren()
    
    for i = 1, #f do
        local group = self.Fixtures[i]:GetChildren()
        
        for ii = 1, #group do
            fixtures[#fixtures + 1] = group[ii]
        end
    end
    
    return fixtures
end

function CPS:init()
    local clamp = function(x, y, z)
        return x >= z and z or x <= y and y or x
    end

    local split = function(s, x, y)
        return s:sub(1, x), s:sub(y, s:len())
    end

    for _, v in pairs(self:GetFixtures()) do
        if self.Settings.FixturesEnabled then
            v.Control.Disabled = false
            if self.Settings.FixturesUpdating then
                for attribute, tbl in pairs(self.Attributes) do
                    local value, args = clamp(tbl.default, tbl.min, tbl.max)
                    
                    self:UpdateFixtures("All", attribute, value)
                end
            end
        end
    end

    self.updaters["All"] = function(att, value)
        for _, v in pairs(self:GetFixtures()) do
            v.Control[att.main].Value = clamp(value, att.min, att.max)
        end
    end
    

    for _, v in pairs(self.groups) do
        if string.match(v, "G") then
            self.updaters[v] = function(att, value)
                local s1, s2 = split(group, 1, 2)
                local GR1, GR2 = group, concat(s1, "R", s2))

                local Value = clamp(value, att.min, att.max)

                for _, v in pairs(self.Fixtures[GR1]:GetChildren()) do
                    v.Control[attribute].Value = Value
                end

                for _, v in pairs(self.Fixtures[GR2]:GetChildren()) do
                    v.Control[attribute].Value = Value
                end
            end
        end
    end
end

debug.profileend("CHandler")

return CPS
