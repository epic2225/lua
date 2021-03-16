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
    settings = {
        fixturesEnabled = true; --Set to false to completely disable all fixture controllers
        fixturesUpdating = true; --Set to false to stop updating the attributes of the fixtures
        effectsEnabled = true; --Set to false to stop any effect from being enabled and/or to disable all effects
        effectsUpdating = true; --Set to false to stop effects from updating to the fixtures
        effectsRunning = false; --Set to true to run all effects on start
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
    
    effects = {
        sin = {
            speed = {min=0,max=10,default=3},
            phase = {min=0,max=360,default=45},
            fx = {
                pan = {enabled=false,phase=-90,size=45},
                tilt = {enabled=false,phase=0,size=45},
                dim = {enabled=false,phase=0,size=255},
                zoom = {enabled=false,phase=0,size=255},
            }
        },
        rampUp = {
            speed = {min=0,max=10,default=3},
            phase = {min=0,max=360,default=22.5},
            fx = {
                dim = {enabled=false,phase=0,size=255},
                color = {enabled=false,phase=0,size=255},
                pan = {enabled=false,phase=0,size=45},
                tilt = {enabled=false,phase=0,size=45},
            }
        },
        rampDown = {
            speed = {min=0,max=10,default=3},
            phase = {min=0,max=360,default=22.5},
            fx = {
                dim = {enabled=false,phase=0,size=255},
                color = {enabled=false,phase=0,size=255},
                pan = {enabled=false,phase=0,size=45},
                tilt = {enabled=false,phase=0,size=45},
            }
        },
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

local effectRunner = require(script.Parent.EffectEngine)

--Functions

local debugMode = false

local dPrint = function(...) if (debugMode) then print(...) end end

local reverse = function(bool)
    return ({
        [true] = false;
        [false] = true;
    })[bool]
end



function CPS:UpdateFixtures(group, attribute, value)
    if self.settings.fixturesUpdating then
        local att = self.Attributes[attribute]

        self.updaters[group](att, value)
    end
end

function CPS:GetFixtures()
    local groups = {}
    local f = self.Fixtures:GetChildren()
    
    for k, v in pairs(f) do
        groups[v.Name] = v
    end
    
    return groups
end

function CPS:GetAllFixtures()
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
    local util = {
        clamp = function(x, y, z)
            return x >= z and z or x <= y and y or x
        end,

        split = function(s, x, y)
            return s:sub(1, x), s:sub(y, s:len())
        end,
        
        find = function(tbl, value)
            for k, v in pairs(tbl) do
                if v == value then
                    return v
                end
            end
        end,
    }
    
    --start updaters

    self.updaters["All"] = function(att, value)
        for _, v in pairs(self:GetFixtures()) do
            v.Control[att.main]:Fire(util.clamp(value, att.min, att.max))
        end
    end
    
    for _, v in pairs(self.groups) do
        if string.match(v, "G") then
            self.updaters[v] = function(att, value)
                local s1, s2 = util.split(group, 1, 2)
                local GR1, GR2 = group, concat(s1, "R", s2)
                local Value = clamp(value, att.min, att.max)

                for _, v in pairs(self.Fixtures[GR1]:GetChildren()) do
                    v.Control[attribute]:Fire(Value)
                end

                for _, v in pairs(self.Fixtures[GR2]:GetChildren()) do
                    v.Control[attribute]:Fire(Value)
                end
            end
        end
    end

    --reset fixtures to default
    
    for _, v in pairs(self.Fixtures:GetFixtures()) do
        if self.settings.fixturesEnabled then
            v.Control.Disabled = false
            if self.Settings.FixturesUpdating then
                for attribute, tbl in pairs(self.Attributes) do
                    local value, args = util.clamp(tbl.default, tbl.min, tbl.max)
                    
                    self:UpdateFixtures("All", attribute, value)
                end
            end
        end
    end
    
    --start effects
    
    for name, group in pairs(self.effects) do
        group.speed.value = util.clamp(group.speed.default, group.speed.min, group.speed.max)
        group.phase.value = util.clamp(group.phase.default, group.phase.min, group.phase.max)
        for k, effect in pairs(v.fx) do
            if not self.settings.effectsEnabled then
                effect.enabled = false
            else
                effect.x = 0
                if self.settings.effectsRunning then
                    if effect.enabled then
                        local run, pause, effects = effectRunner()
                        
                        if effects.running[k] == effect then
                            pause("CLPakyScenius", k, effect)
                        end
                    end
                else
                    if effect.enabled then
                        local run, pause, effects = effectRunner()
                        
                        if effects.running[k] == effect then
                            pause("CLPakyScenius", k, effect)
                        end
                    end
                end
            end
        end
    end
end

debug.profileend("CHandler")

return CPS
