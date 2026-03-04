-- chunkname: @scripts/unit_extensions/generic/shadow_flare_extension.lua

ShadowFlareExtension = class(ShadowFlareExtension)

ShadowFlareExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.owner_unit_id = arg_1_3.owner_unit_id
	arg_1_0.glow_time = arg_1_3.glow_time or 10
	arg_1_0.delete_time = arg_1_3.delete_time or 3
	arg_1_0.initial_position = arg_1_3.initial_position
	arg_1_0._timer = 0
	arg_1_0._delete_timer = 0
	arg_1_0._flare_done = false

	local var_1_0 = Managers.state.unit_storage:unit(arg_1_0.owner_unit_id)

	arg_1_0._player = Managers.player:owner(var_1_0)
end

ShadowFlareExtension.flare_active = function (arg_2_0)
	return not arg_2_0._flare_done
end

ShadowFlareExtension.set_flare_done = function (arg_3_0)
	arg_3_0._flare_done = true
end

ShadowFlareExtension.update = function (arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._player.remote then
		return
	end

	local var_4_0 = arg_4_0.glow_time
	local var_4_1 = arg_4_0._timer

	if var_4_1 < 1 then
		local var_4_2 = math.clamp(var_4_1 + arg_4_2 / var_4_0, 0, 1)

		if var_4_2 == 1 then
			local var_4_3 = Managers.state.network
			local var_4_4 = var_4_3:unit_game_object_id(arg_4_1)

			if arg_4_0._player.is_server then
				var_4_3.network_transmit:send_rpc_clients("rpc_shadow_flare_done", var_4_4)
			else
				var_4_3.network_transmit:send_rpc_server("rpc_shadow_flare_done", var_4_4)
			end

			arg_4_0:set_flare_done()
		end

		arg_4_0._timer = var_4_2
	end

	if arg_4_0._flare_done then
		arg_4_0:delete_with_delay(arg_4_1, arg_4_2)
	end
end

ShadowFlareExtension.delete_with_delay = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.delete_time
	local var_5_1 = arg_5_0._delete_timer

	if var_5_1 < 1 then
		var_5_1 = math.clamp(var_5_1 + arg_5_2 / var_5_0, 0, 1)

		if var_5_1 == 1 then
			Managers.state.unit_spawner:mark_for_deletion(arg_5_1)
		end
	end

	arg_5_0._delete_timer = var_5_1
end
