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

function CPS:UpdateFixtures(attribute, value)
    for i = 1, #self.Fixtures:GetChildren() do
        for ii = 1, #self.Fixtures:GetChildren()[i]:GetChildren() do
            self.Fixtures:GetChildren()[i]:GetChildren()[ii].Controller[attribute].Value = value
        end
    end
end

function CPS:GetFixtureAttributes()
    local att = {}
    
    for i = 1, #self.Fixtures:GetChildren() do
        for ii = 1, #self.Fixtures:GetChildren()[i]:GetChildren() do
            local index = self.Fixtures:GetChildren()[i].Name
            
            att[index] = self.Fixtures:GetChildren()[i]:GetChildren()[ii].Controller
        end
    end
    
    return att
end

debug.profileend("CHandler")

return CPS
