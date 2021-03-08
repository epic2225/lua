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
        EffectsUpdating = true; --Set to false to stop updating the effects
    };
    
    Fixtures = workspace.CLPakyScenius;
    Effects = workspace.Effects;
    
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
}

--Functions

local debugMode = false

local print = function(...) if (debugMode) then print(...) end end

local reverse = function(bool)
    return ({
        [true] = false;
        [false] = true;
    })[bool]
end

function CPS:FindEffect(effectIndex, subIndex)
    return self:FindEffect(effectIndex)[subIndex]
end

function CPS:UpdateEffect(effectIndex, bool)
    self.Effects[effectIndex].Disabled = reverse(bool);
end

function CPS:ChangeEffectSpeed(index1, index2, spd)
    if (index1 == "All") and (spd == nil) then
        for _, v in pairs(self.FX) do
            for _, vv in pairs(v) do
                vv.Speed = index2
            end
        end
    else
        self.FX[index1][index2].Speed = spd
    end
end

function CPS:UpdateFixtures(group, attribute, value)
    local split = function(s, x, y)
        return s:sub(1, x), s:sub(y, s:len())
    end
    
    if group == "All" then
        local fixtures = self.Fixtures:GetChildren()
        
        for i = 1, #fixtures do
            local fixtureGroup = fixtures[i]:GetChildren()
            
            for ii = 1, #fixtureGroup do
                fixtureGroup[ii].Control[attribute].Value = value
            end
        end
    else
        local s1, s2 = split(group, 1, 2)
        local groups = {p = group, s = s1 .. "R" .. s2}
        
        local gr1 = self.Fixtures[groups.p]:GetChildren()
        local gr2 = self.Fixtures[groups.s]:GetChildren()
        
        for i = 1, #gr1 do
            gr1[i].Control[attribute].Value = value
        end
        
        for i = 1, #gr2 do
            gr2[i].Control[attribute].Value = value
        end
    end
end

function CPS:GetFixtures()
    local fixtures = {}
    local f = self.Fixtures:GetChildren()
    
    for i = 1, #f do
        local group = self.Fixtures[i]:GetChildren()
        
        for ii = 1, #group do
            fixtures[i + (#group * (i - 1))] = group[ii]
        end
    end
    
    return fixtures
end

debug.profileend("CHandler")

return CPS
