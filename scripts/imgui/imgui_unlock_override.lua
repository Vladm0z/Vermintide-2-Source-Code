-- chunkname: @scripts/imgui/imgui_unlock_override.lua

ImguiUnlockOverride = class(ImguiUnlockOverride)

ImguiUnlockOverride.init = function (self)
	-- function 1
	return
end

ImguiUnlockOverride.update = function (self)
	-- function 2
	return
end

local dlc_list = {}

local function set_all(t, k, v)
	-- function 3
	for i = 1, #k do
		t[k[i]] = v
	end
end

ImguiUnlockOverride.draw = function (self)
	-- function 4
	return
end

ImguiUnlockOverride.is_persistent = function (self)
	-- function 5
	return false
end
