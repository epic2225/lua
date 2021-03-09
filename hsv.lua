return function(h, sat, val)
    local v = (h % 360)
    
    local r, r2 = 0, 0
	local g, g2 = 0, 0
	local b, b2 = 0, 0
	
	if v <= 240 then r = 0
    elseif v >= 300 then r = 1
    else r = ((v - 240) / 60) end
    if v <= 60 then r2 = 1
    elseif v >= 120 then r2 = 0
    else r2 = 1 - ((v - 60) / 60) end
	
    if v <= 0 then g = 0
    elseif v >= 60 then g = 1
    else g = (v / 60) end
    if v <= 180 then g2 = 1
    elseif v >= 240 then g2 = 0
    else g2 = 1 - ((v - 180) / 60) end
    
    if v <= 120 then b2 = 0
    elseif v >= 180 then b2 = 1
    else b2 = ((v - 120) / 60) end
    if v >= 360 then b = 0
    elseif v <= 300 then b = 1
    else b = 1 - ((v - 300) / 60) end
        
    local red = math.floor((r + r2) * 255)
	local green = math.floor((g + g2) * 255) - 255
	local blue = math.floor((b + b2) * 255) - 255
    
    local function mix(s, v, r, g, b)
        local clamp = function(x, y, z) if x < y then return y elseif x > z then return z else return x end end
        local lerp = function(...) local args = {...} return args[1] * (1 - args[3]) + args[2] * args[3] end
        
        local S = clamp(s, 0, 255) / 255
        local V = clamp(v, 0, 255) / 255
        
        local R = clamp(r, 0, 255)
        local G = clamp(g, 0, 255)
        local B = clamp(b, 0, 255)
        
        local sat_R = (lerp(R, 255, 1 - S))
        local sat_G = (lerp(G, 255, 1 - S))
        local sat_B = (lerp(B, 255, 1 - S))
        
        local val_R = (lerp(sat_R, 0, 1 - V))
        local val_G = (lerp(sat_G, 0, 1 - V))
        local val_B = (lerp(sat_B, 0, 1 - V))
        
        return math.floor(val_R), math.floor(val_G), math.floor(val_B)
    end
    
    return mix(sat, val, red, green, blue)
end
