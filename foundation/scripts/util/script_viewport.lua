-- chunkname: @foundation/scripts/util/script_viewport.lua

local ScriptViewport = ScriptViewport

ScriptViewport = ScriptViewport or {}
ScriptViewport = ScriptViewport

ScriptViewport.active = function (arg_1_0)
	-- function 1
	return Viewport.get_data(arg_1_0, "active")
end

ScriptViewport.camera = function (arg_2_0)
	-- function 2
	return Viewport.get_data(arg_2_0, "camera")
end

ScriptViewport.shadow_cull_camera = function (arg_3_0)
	-- function 3
	return Viewport.get_data(arg_3_0, "shadow_cull_camera")
end
