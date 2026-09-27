-- chunkname: @scripts/unit_extensions/generic/kill_volume_handler_extension.lua

KillVolumeHandlerExtension = class(KillVolumeHandlerExtension)

KillVolumeHandlerExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._callbacks = {}
end

KillVolumeHandlerExtension.game_object_initialized = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	return
end

KillVolumeHandlerExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

KillVolumeHandlerExtension.add_handler = function (arg_4_0, arg_4_1)
	-- function 4
	arg_4_0._callbacks[#arg_4_0._callbacks + 1] = arg_4_1
end

KillVolumeHandlerExtension.on_hit_kill_volume = function (self)
	-- function 5
	local flag = false

	for i = 1, #self._callbacks do
		flag = self._callbacks[i]() or flag
	end

	return flag
end
