-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_taunt_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTauntAction = class(BTTauntAction, BTNode)

BTTauntAction.init = function (arg_1_0, ...)
	-- function 1
	BTTauntAction.super.init(arg_1_0, ...)
end

BTTauntAction.name = "BTTauntAction"

BTTauntAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	print("TAUNT")

	local action_data = self._tree_node.action_data
	local var_2_1 = Managers.state.side.side_by_unit[arg_2_1]
	local var_2_2 = POSITION_LOOKUP[arg_2_1]
	local radius = action_data.radius
	local duration = action_data.duration
	local alloc_table = FrameTable.alloc_table()
	local enemy_broadphase_categories = var_2_1.enemy_broadphase_categories
	local broadphase_query = AiUtils.broadphase_query(var_2_2, radius, alloc_table, enemy_broadphase_categories)

	for i = 1, broadphase_query do
		local var_2_8 = alloc_table[i]
		local var_2_9 = BLACKBOARDS[var_2_8]
		local override_targets = var_2_9.override_targets

		table.clear(override_targets)

		var_2_9.target_unit = nil
		override_targets[arg_2_1] = arg_2_3 + duration
	end

	local effect_name = action_data.effect_name

	if not effect_name then
		local var_2_12 = NetworkLookup.effects[effect_name]
		local num = 0
		local flag = false

		Managers.state.network:rpc_play_particle_effect_no_rotation(nil, var_2_12, NetworkConstants.invalid_game_object_id, num, var_2_2, flag)
	end

	local sound_event = action_data.sound_event

	if not sound_event then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(sound_event, arg_2_1)
	end
end

BTTauntAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

BTTauntAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	return "done"
end
