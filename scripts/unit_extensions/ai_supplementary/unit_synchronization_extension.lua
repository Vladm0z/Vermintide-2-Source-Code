-- chunkname: @scripts/unit_extensions/ai_supplementary/unit_synchronization_extension.lua

UnitSynchronizationExtension = class(UnitSynchronizationExtension)

local var_0_0 = POSITION_LOOKUP

UnitSynchronizationExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = Managers.player.is_server
end

UnitSynchronizationExtension.update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if arg_2_0.is_server then
		arg_2_0:_server_sync_position_rotation(arg_2_3, arg_2_5)
	else
		arg_2_0:_client_validate_position_rotation(arg_2_3, arg_2_5)
	end
end

UnitSynchronizationExtension._server_sync_position_rotation = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = Managers.state.network:game()

	if var_3_0 then
		local var_3_1 = GameSession.set_game_object_field
		local var_3_2 = Managers.state.unit_storage
		local var_3_3 = Unit.local_rotation
		local var_3_4 = NetworkConstants.position.min
		local var_3_5 = NetworkConstants.position.max
		local var_3_6 = arg_3_0.unit
		local var_3_7 = var_3_2:go_id(var_3_6)
		local var_3_8 = Vector3.clamp(var_0_0[var_3_6], var_3_4, var_3_5)
		local var_3_9 = var_3_3(var_3_6, 0)

		var_3_1(var_3_0, var_3_7, "position", var_3_8)
		var_3_1(var_3_0, var_3_7, "rotation", var_3_9)
	end
end

local var_0_1 = 0.0001

UnitSynchronizationExtension._client_validate_position_rotation = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = Managers.state.network:game()

	if var_4_0 then
		local var_4_1 = GameSession.game_object_field
		local var_4_2 = Vector3.distance_squared
		local var_4_3 = Unit.local_position
		local var_4_4 = Managers.state.unit_storage
		local var_4_5 = arg_4_0.unit
		local var_4_6 = var_4_4:go_id(var_4_5)
		local var_4_7 = var_4_1(var_4_0, var_4_6, "position")
		local var_4_8 = var_0_0[var_4_5] or var_4_3(var_4_5, 0)

		if var_4_2(var_4_7, var_4_8) > var_0_1 then
			local var_4_9 = var_4_1(var_4_0, var_4_6, "rotation")

			Unit.set_local_position(var_4_5, 0, var_4_7)
			Unit.set_local_rotation(var_4_5, 0, var_4_9)
		end
	end
end
