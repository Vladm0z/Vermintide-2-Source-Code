-- chunkname: @scripts/unit_extensions/generic/kill_volume_handler_extension.lua

KillVolumeHandlerExtension = class(KillVolumeHandlerExtension)

KillVolumeHandlerExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self._callbacks = {}
end

KillVolumeHandlerExtension.game_object_initialized = function (self, unit, go_id)
	-- function 2
	return
end

KillVolumeHandlerExtension.destroy = function (self)
	-- function 3
	return
end

KillVolumeHandlerExtension.add_handler = function (self, on_hit_kill_volume_cb)
	-- function 4
	self._callbacks[#self._callbacks + 1] = on_hit_kill_volume_cb
end

KillVolumeHandlerExtension.on_hit_kill_volume = function (self)
	-- function 5
	local handled = false

	for i = 1, #self._callbacks do
		local cb = self._callbacks[i]

		handled = not not cb() or not not handled
	end

	return handled
end
