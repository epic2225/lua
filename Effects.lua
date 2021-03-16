local effectEngine = {started = false}
local effects = {running = {}, archived = {}}

local function call(func, ...)
    func(...)
end

function effectEngine:runEffect(fixture, id, effect)
    local templateEffect = {
        enabled = false,
        phase = 0,
    }
end

function effectEngine:init()
    started = true
    
    for k, v in pairs(effects.archived) do
        if v.enabled then
            
        end
    end
end



return function()
    if not effectEngine.started then
        effectEngine:init()
    end
    
    return effectEngine:effectRunner, effectEngine:effectPauser, effects
end
