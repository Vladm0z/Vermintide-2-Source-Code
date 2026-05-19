-- chunkname: @scripts/unit_extensions/generic/kill_volume_handler_extension.lua

KillVolumeHandlerExtension = class(KillVolumeHandlerExtension)

function KillVolumeHandlerExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._callbacks = {}
end

function KillVolumeHandlerExtension.game_object_initialized(arg_2_0, arg_2_1, arg_2_2)
	return
end

function KillVolumeHandlerExtension.destroy(arg_3_0)
	return
end

function KillVolumeHandlerExtension.add_handler(arg_4_0, arg_4_1)
	arg_4_0._callbacks[#arg_4_0._callbacks + 1] = arg_4_1
end

function KillVolumeHandlerExtension.on_hit_kill_volume(arg_5_0)
	local var_5_0 = false

	for iter_5_0 = 1, #arg_5_0._callbacks do
		var_5_0 = arg_5_0._callbacks[iter_5_0]() or var_5_0
	end

	return var_5_0
end
