local effectEngine = {started = false}
local effects = {running = {}, archived = {}}

local function call(func, ...)
    func(...)
end

local waveforms = {
    sin = function(x, phase)
        return (math.sin(x + rad(phase)) + 1) / 2
    end,
}

function effectEngine:runEffect(fixture, waveform, id, effect)
    if effects.running[id] then
        effects.running[id] = nil
    end
    effects.running[id] = effect
    
    local effectIndex = {
        ["CLPakyScenius"] = function()
            local CHandler = require(script.Parent.CHandler)
            effect.x = effect.x + (CHandler.effects[waveform].speed.value / 100)
            
            for k, v in pairs(CHandler:GetFixtures()) do
                for _, vv in pairs(v:GetChildren()) do
                    local pos = waveforms[waveform](effect.x, CHandler.effects[waveform].phase.value * k)
                    
                    CHandler:UpdateFixtures("G" .. tostring(k), effect.attribute, pos)
                end
            end
        end,
    }
    
    effectIndex[fixture]()
end

function effectEngine:init()
    started = true
    
    for k, v in pairs(effects.archived) do
        if v.enabled then
            self:runEffect(
            effects.archived[k] = nil
        end
    end
end



return function()
    if not effectEngine.started then
        effectEngine:init()
    end
end
