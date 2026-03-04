-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_shield_user_husk_extension.lua

AIShieldUserHuskExtension = class(AIShieldUserHuskExtension)

AIShieldUserHuskExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0.is_blocking = arg_1_3.is_blocking
	arg_1_0.is_dodging = arg_1_3.is_dodging
end

AIShieldUserHuskExtension.destroy = function (arg_2_0)
	return
end

AIShieldUserHuskExtension.can_block_attack = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	assert(arg_3_1)

	local var_3_0 = arg_3_0._unit
	local var_3_1 = Managers.state.unit_storage:go_id(var_3_0)
	local var_3_2 = Managers.state.network:game()

	if not GameSession.game_object_field(var_3_2, var_3_1, "is_blocking") then
		return false
	end

	local var_3_3 = Unit.world_position(arg_3_1, 0)
	local var_3_4 = Unit.world_position(var_3_0, 0)
	local var_3_5 = Vector3.normalize(var_3_4 - var_3_3)
	local var_3_6 = Quaternion.forward(Unit.local_rotation(var_3_0, 0))
	local var_3_7
	local var_3_8

	if arg_3_2 then
		local var_3_9 = Vector3.dot(var_3_6, arg_3_3)

		var_3_8 = var_3_9 >= -0.75 and var_3_9 <= 1
	else
		local var_3_10 = Vector3.dot(var_3_6, var_3_5)

		var_3_8 = var_3_10 >= 0.55 and var_3_10 <= 1
	end

	return not var_3_8
end

AIShieldUserHuskExtension.get_is_blocking = function (arg_4_0)
	local var_4_0 = arg_4_0._unit
	local var_4_1 = Managers.state.unit_storage:go_id(var_4_0)
	local var_4_2 = Managers.state.network:game()

	return (GameSession.game_object_field(var_4_2, var_4_1, "is_blocking"))
end
