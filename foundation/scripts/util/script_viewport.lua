-- chunkname: @foundation/scripts/util/script_viewport.lua

ScriptViewport = ScriptViewport or {}

function ScriptViewport.active(arg_1_0)
	return Viewport.get_data(arg_1_0, "active")
end

function ScriptViewport.camera(arg_2_0)
	return Viewport.get_data(arg_2_0, "camera")
end

function ScriptViewport.shadow_cull_camera(arg_3_0)
	return Viewport.get_data(arg_3_0, "shadow_cull_camera")
end
