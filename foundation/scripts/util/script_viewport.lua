-- chunkname: @foundation/scripts/util/script_viewport.lua

ScriptViewport = ScriptViewport or {}

ScriptViewport.active = function (arg_1_0)
	return Viewport.get_data(arg_1_0, "active")
end

ScriptViewport.camera = function (arg_2_0)
	return Viewport.get_data(arg_2_0, "camera")
end

ScriptViewport.shadow_cull_camera = function (arg_3_0)
	return Viewport.get_data(arg_3_0, "shadow_cull_camera")
end
