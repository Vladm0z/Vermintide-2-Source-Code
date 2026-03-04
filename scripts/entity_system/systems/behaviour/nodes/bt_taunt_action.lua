-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_taunt_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTauntAction = class(BTTauntAction, BTNode)

BTTauntAction.init = function (arg_1_0, ...)
	BTTauntAction.super.init(arg_1_0, ...)
end

BTTauntAction.name = "BTTauntAction"

BTTauntAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	print("TAUNT")

	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = Managers.state.side.side_by_unit[arg_2_1]
	local var_2_2 = POSITION_LOOKUP[arg_2_1]
	local var_2_3 = var_2_0.radius
	local var_2_4 = var_2_0.duration
	local var_2_5 = FrameTable.alloc_table()
	local var_2_6 = var_2_1.enemy_broadphase_categories
	local var_2_7 = AiUtils.broadphase_query(var_2_2, var_2_3, var_2_5, var_2_6)

	for iter_2_0 = 1, var_2_7 do
		local var_2_8 = var_2_5[iter_2_0]
		local var_2_9 = BLACKBOARDS[var_2_8]
		local var_2_10 = var_2_9.override_targets

		table.clear(var_2_10)

		var_2_9.target_unit = nil
		var_2_10[arg_2_1] = arg_2_3 + var_2_4
	end

	local var_2_11 = var_2_0.effect_name

	if var_2_11 then
		local var_2_12 = NetworkLookup.effects[var_2_11]
		local var_2_13 = 0
		local var_2_14 = false

		Managers.state.network:rpc_play_particle_effect_no_rotation(nil, var_2_12, NetworkConstants.invalid_game_object_id, var_2_13, var_2_2, var_2_14)
	end

	local var_2_15 = var_2_0.sound_event

	if var_2_15 then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_2_15, arg_2_1)
	end
end

BTTauntAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

BTTauntAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	return "done"
end
