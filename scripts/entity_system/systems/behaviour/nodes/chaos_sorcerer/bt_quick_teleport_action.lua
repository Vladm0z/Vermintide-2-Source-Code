-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_quick_teleport_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTQuickTeleportAction = class(BTQuickTeleportAction, BTNode)

BTQuickTeleportAction.init = function (arg_1_0, ...)
	BTQuickTeleportAction.super.init(arg_1_0, ...)
end

BTQuickTeleportAction.name = "BTQuickTeleportAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

BTQuickTeleportAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = BTQuickTeleportAction

	if var_3_0.sound_event then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_3_0.sound_event, arg_3_1)
	end

	if arg_3_2.action.force_teleport then
		arg_3_2.quick_teleport = true
	end

	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	arg_3_2.navigation_extension:set_enabled(false)

	if var_3_0.teleport_start_anim then
		Managers.state.network:anim_event(arg_3_1, var_0_0(var_3_0.teleport_start_anim))
	end

	if var_3_0.push_close_players then
		arg_3_2.hit_units = {}
	end

	if arg_3_2.action.teleport_start_function then
		arg_3_2.action.teleport_start_function(arg_3_1, arg_3_2)
	end
end

BTQuickTeleportAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.quick_teleport_exit_pos = nil
	arg_4_2.active_node = nil
	arg_4_2.quick_teleport = false

	arg_4_2.navigation_extension:set_enabled(true)

	arg_4_2.face_player_when_teleporting = false

	if arg_4_2.action.push_close_players then
		arg_4_2.hit_units = nil
	end
end

BTQuickTeleportAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not arg_5_2.action.teleport_start_anim then
		arg_5_0:anim_cb_teleport_start_finished(arg_5_1, arg_5_2)
	end

	if not arg_5_2.action.teleport_end_anim then
		arg_5_0:anim_cb_teleport_end_finished(arg_5_1, arg_5_2)
	end

	if not arg_5_2.quick_teleport then
		return "done"
	end

	return "running"
end

BTQuickTeleportAction.play_teleport_effect = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_2.action
	local var_6_1 = var_6_0.teleport_effect

	if var_6_1 then
		local var_6_2 = NetworkLookup.effects[var_6_1]
		local var_6_3 = 0
		local var_6_4 = Quaternion.identity()
		local var_6_5 = Managers.state.network

		var_6_5:rpc_play_particle_effect(nil, var_6_2, NetworkConstants.invalid_game_object_id, var_6_3, arg_6_3, var_6_4, false)

		if not var_6_0.teleport_end_effect then
			var_6_5:rpc_play_particle_effect(nil, var_6_2, NetworkConstants.invalid_game_object_id, var_6_3, arg_6_4, var_6_4, false)
		end
	end

	local var_6_6 = var_6_0.teleport_effect_trail

	if var_6_6 then
		local var_6_7 = Managers.state.network
		local var_6_8 = 0
		local var_6_9 = Vector3.normalize(arg_6_3 - arg_6_4)
		local var_6_10 = Quaternion.look(var_6_9, Vector3.up())
		local var_6_11 = NetworkLookup.effects[var_6_6]

		var_6_7:rpc_play_particle_effect(nil, var_6_11, NetworkConstants.invalid_game_object_id, var_6_8, arg_6_3, var_6_10, false)

		if not var_6_0.teleport_end_effect then
			var_6_7:rpc_play_particle_effect(nil, var_6_11, NetworkConstants.invalid_game_object_id, var_6_8, arg_6_4, var_6_10, false)
		end
	end

	local var_6_12 = arg_6_2.breed
	local var_6_13 = Managers.state.entity:system("audio_system")

	if var_6_12.teleport_sound_event then
		var_6_13:play_audio_unit_event(var_6_12.teleport_sound_event, arg_6_1)
	end
end

BTQuickTeleportAction.anim_cb_teleport_start_finished = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = POSITION_LOOKUP[arg_7_1]
	local var_7_1
	local var_7_2 = arg_7_2.action.teleport_pos_func

	if var_7_2 then
		var_7_1 = var_7_2(arg_7_1, arg_7_2)
	else
		var_7_1 = arg_7_2.quick_teleport_exit_pos:unbox()
	end

	if not var_7_1 then
		return
	end

	arg_7_2.navigation_extension:set_navbot_position(var_7_1)
	arg_7_2.locomotion_extension:teleport_to(var_7_1)
	Managers.state.entity:system("ai_bot_group_system"):enemy_teleported(arg_7_1, var_7_1)
	arg_7_0:play_teleport_effect(arg_7_1, arg_7_2, var_7_0, var_7_1)

	if arg_7_2.action.remove_pings then
		Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_7_1)
	end

	if arg_7_2.action.push_close_players then
		local var_7_3 = arg_7_2.side.ENEMY_PLAYER_AND_BOT_UNITS

		for iter_7_0 = 1, #var_7_3 do
			local var_7_4 = var_7_3[iter_7_0]

			arg_7_0:push_close_players(arg_7_1, arg_7_2, var_7_0, var_7_4)
		end
	end

	local var_7_5 = arg_7_2.target_unit

	if arg_7_2.face_player_when_teleporting and Unit.alive(var_7_5) then
		local var_7_6 = POSITION_LOOKUP[var_7_5]
		local var_7_7 = Vector3.flat(var_7_6 - var_7_1)
		local var_7_8 = Quaternion.look(var_7_7, Vector3.up())

		Unit.set_local_rotation(arg_7_1, 0, var_7_8)
	end

	if arg_7_2.action.teleport_end_anim then
		Managers.state.network:anim_event(arg_7_1, arg_7_2.action.teleport_end_anim)
	end

	arg_7_2.teleport_at_t = Managers.time:time("game")
end

BTQuickTeleportAction.anim_cb_teleport_end_finished = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_2.quick_teleport = false
end

BTQuickTeleportAction.anim_cb_tp_end_enter = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.action

	if var_9_0.teleport_end_effect then
		local var_9_1 = NetworkLookup.effects[var_9_0.teleport_end_effect]
		local var_9_2 = 0
		local var_9_3 = Quaternion.identity()
		local var_9_4 = POSITION_LOOKUP[arg_9_1]

		Managers.state.network:rpc_play_particle_effect(nil, var_9_1, NetworkConstants.invalid_game_object_id, var_9_2, var_9_4, var_9_3, false)
	end
end

BTQuickTeleportAction.push_close_players = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_2.action
	local var_10_1 = var_10_0.radius
	local var_10_2 = var_10_0.push_speed
	local var_10_3 = var_10_0.push_speed_z
	local var_10_4 = arg_10_2.hit_units
	local var_10_5 = POSITION_LOOKUP[arg_10_4] - arg_10_3
	local var_10_6 = Vector3.length(Vector3.flat(var_10_5))

	if not var_10_4[arg_10_4] and var_10_6 < var_10_1 then
		local var_10_7 = var_10_2 * Vector3.normalize(var_10_5)

		if var_10_3 then
			Vector3.set_z(var_10_7, var_10_3)
		end

		if var_10_0.catapult_players then
			StatusUtils.set_catapulted_network(arg_10_4, true, var_10_7)
		else
			ScriptUnit.extension(arg_10_4, "locomotion_system"):add_external_velocity(var_10_7)
		end

		var_10_4[arg_10_4] = true
	end
end
