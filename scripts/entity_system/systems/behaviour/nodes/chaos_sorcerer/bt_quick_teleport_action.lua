-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_quick_teleport_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTQuickTeleportAction = class(BTQuickTeleportAction, BTNode)

BTQuickTeleportAction.init = function (arg_1_0, ...)
	-- function 1
	BTQuickTeleportAction.super.init(arg_1_0, ...)
end

BTQuickTeleportAction.name = "BTQuickTeleportAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTQuickTeleportAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = BTQuickTeleportAction

	if not action_data.sound_event then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(action_data.sound_event, arg_3_1)
	end

	if not arg_3_2.action.force_teleport then
		arg_3_2.quick_teleport = true
	end

	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	arg_3_2.navigation_extension:set_enabled(false)

	if not action_data.teleport_start_anim then
		Managers.state.network:anim_event(arg_3_1, fn(action_data.teleport_start_anim))
	end

	if not action_data.push_close_players then
		arg_3_2.hit_units = {}
	end

	if not arg_3_2.action.teleport_start_function then
		arg_3_2.action.teleport_start_function(arg_3_1, arg_3_2)
	end
end

BTQuickTeleportAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.quick_teleport_exit_pos = nil
	arg_4_2.active_node = nil
	arg_4_2.quick_teleport = false

	arg_4_2.navigation_extension:set_enabled(true)

	arg_4_2.face_player_when_teleporting = false

	if not arg_4_2.action.push_close_players then
		arg_4_2.hit_units = nil
	end
end

BTQuickTeleportAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not arg_5_2.action.teleport_start_anim then
		self:anim_cb_teleport_start_finished(arg_5_1, arg_5_2)
	end

	if not arg_5_2.action.teleport_end_anim then
		self:anim_cb_teleport_end_finished(arg_5_1, arg_5_2)
	end

	if not arg_5_2.quick_teleport then
		return "done"
	end

	return "running"
end

BTQuickTeleportAction.play_teleport_effect = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local action = arg_6_2.action
	local teleport_effect = action.teleport_effect

	if not teleport_effect then
		local var_6_2 = NetworkLookup.effects[teleport_effect]
		local num = 0
		local identity = Quaternion.identity()
		local network = Managers.state.network

		network:rpc_play_particle_effect(nil, var_6_2, NetworkConstants.invalid_game_object_id, num, arg_6_3, identity, false)

		if not action.teleport_end_effect then
			network:rpc_play_particle_effect(nil, var_6_2, NetworkConstants.invalid_game_object_id, num, arg_6_4, identity, false)
		end
	end

	local teleport_effect_trail = action.teleport_effect_trail

	if not teleport_effect_trail then
		local network_2 = Managers.state.network
		local num_2 = 0
		local normalize = Vector3.normalize(arg_6_3 - arg_6_4)
		local look = Quaternion.look(normalize, Vector3.up())
		local var_6_11 = NetworkLookup.effects[teleport_effect_trail]

		network_2:rpc_play_particle_effect(nil, var_6_11, NetworkConstants.invalid_game_object_id, num_2, arg_6_3, look, false)

		if not action.teleport_end_effect then
			network_2:rpc_play_particle_effect(nil, var_6_11, NetworkConstants.invalid_game_object_id, num_2, arg_6_4, look, false)
		end
	end

	local breed = arg_6_2.breed
	local system = Managers.state.entity:system("audio_system")

	if not breed.teleport_sound_event then
		system:play_audio_unit_event(breed.teleport_sound_event, arg_6_1)
	end
end

BTQuickTeleportAction.anim_cb_teleport_start_finished = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = POSITION_LOOKUP[arg_7_1]
	local var_7_1
	local teleport_pos_func = arg_7_2.action.teleport_pos_func

	if not teleport_pos_func then
		var_7_1 = teleport_pos_func(arg_7_1, arg_7_2)
	else
		var_7_1 = arg_7_2.quick_teleport_exit_pos:unbox()
	end

	if not var_7_1 then
		return
	end

	arg_7_2.navigation_extension:set_navbot_position(var_7_1)
	arg_7_2.locomotion_extension:teleport_to(var_7_1)
	Managers.state.entity:system("ai_bot_group_system"):enemy_teleported(arg_7_1, var_7_1)
	self:play_teleport_effect(arg_7_1, arg_7_2, var_7_0, var_7_1)

	if not arg_7_2.action.remove_pings then
		Managers.state.entity:system("ping_system"):remove_ping_from_unit(arg_7_1)
	end

	if not arg_7_2.action.push_close_players then
		local ENEMY_PLAYER_AND_BOT_UNITS = arg_7_2.side.ENEMY_PLAYER_AND_BOT_UNITS

		for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
			local var_7_4 = ENEMY_PLAYER_AND_BOT_UNITS[i]

			self:push_close_players(arg_7_1, arg_7_2, var_7_0, var_7_4)
		end
	end

	local target_unit = arg_7_2.target_unit

	if not arg_7_2.face_player_when_teleporting and not Unit.alive(target_unit) then
		local var_7_6 = POSITION_LOOKUP[target_unit]
		local flat = Vector3.flat(var_7_6 - var_7_1)
		local look = Quaternion.look(flat, Vector3.up())

		Unit.set_local_rotation(arg_7_1, 0, look)
	end

	if not arg_7_2.action.teleport_end_anim then
		Managers.state.network:anim_event(arg_7_1, arg_7_2.action.teleport_end_anim)
	end

	arg_7_2.teleport_at_t = Managers.time:time("game")
end

BTQuickTeleportAction.anim_cb_teleport_end_finished = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	arg_8_2.quick_teleport = false
end

BTQuickTeleportAction.anim_cb_tp_end_enter = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local action = arg_9_2.action

	if not action.teleport_end_effect then
		local var_9_1 = NetworkLookup.effects[action.teleport_end_effect]
		local num = 0
		local identity = Quaternion.identity()
		local var_9_4 = POSITION_LOOKUP[arg_9_1]

		Managers.state.network:rpc_play_particle_effect(nil, var_9_1, NetworkConstants.invalid_game_object_id, num, var_9_4, identity, false)
	end
end

BTQuickTeleportAction.push_close_players = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local action = arg_10_2.action
	local radius = action.radius
	local push_speed = action.push_speed
	local push_speed_z = action.push_speed_z
	local hit_units = arg_10_2.hit_units
	local num = POSITION_LOOKUP[arg_10_4] - arg_10_3
	local length = Vector3.length(Vector3.flat(num))

	if not (hit_units[arg_10_4] or not (length < radius)) then
		local num_2 = push_speed * Vector3.normalize(num)

		if not push_speed_z then
			Vector3.set_z(num_2, push_speed_z)
		end

		if not action.catapult_players then
			StatusUtils.set_catapulted_network(arg_10_4, true, num_2)
		else
			ScriptUnit.extension(arg_10_4, "locomotion_system"):add_external_velocity(num_2)
		end

		hit_units[arg_10_4] = true
	end
end
