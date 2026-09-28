-- chunkname: @foundation/scripts/util/script_viewport.lua

local ScriptViewport = ScriptViewport

ScriptViewport = not not ScriptViewport or not not {}
ScriptViewport = ScriptViewport

ScriptViewport.active = function (viewport)
	-- function 1
	return Viewport.get_data(viewport, "active")
end

ScriptViewport.camera = function (viewport)
	-- function 2
	return Viewport.get_data(viewport, "camera")
end

ScriptViewport.shadow_cull_camera = function (viewport)
	-- function 3
	return Viewport.get_data(viewport, "shadow_cull_camera")
end
