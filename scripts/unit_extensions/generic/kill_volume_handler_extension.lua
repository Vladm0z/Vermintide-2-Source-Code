-- chunkname: @scripts/unit_extensions/generic/kill_volume_handler_extension.lua

KillVolumeHandlerExtension = class(KillVolumeHandlerExtension)

KillVolumeHandlerExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._callbacks = {}
end

KillVolumeHandlerExtension.game_object_initialized = function (arg_2_0, arg_2_1, arg_2_2)
	return
end

KillVolumeHandlerExtension.destroy = function (arg_3_0)
	return
end

KillVolumeHandlerExtension.add_handler = function (arg_4_0, arg_4_1)
	arg_4_0._callbacks[#arg_4_0._callbacks + 1] = arg_4_1
end

KillVolumeHandlerExtension.on_hit_kill_volume = function (arg_5_0)
	local var_5_0 = false

	for iter_5_0 = 1, #arg_5_0._callbacks do
		var_5_0 = arg_5_0._callbacks[iter_5_0]() or var_5_0
	end

	return var_5_0
end
