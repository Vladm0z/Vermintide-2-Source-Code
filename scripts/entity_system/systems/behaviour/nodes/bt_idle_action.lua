-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTIdleAction = class(BTIdleAction, BTNode)

BTIdleAction.init = function (arg_1_0, ...)
	-- function 1
	BTIdleAction.super.init(arg_1_0, ...)
end

BTIdleAction.name = "BTIdleAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTIdleAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local network = Managers.state.network
	local str = "idle"
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.spawn_to_running = nil

	if not action_data and not action_data.alerted_anims and not arg_3_2.confirmed_player_sighting then
		str = action_data.alerted_anims[math.random(1, #action_data.alerted_anims)]
	elseif not (not action_data and not action_data.idle_combat and arg_3_2.is_passive) then
		str = fn(action_data.idle_combat)
	elseif not action_data and not action_data.idle_animation then
		str = fn(action_data.idle_animation)
	elseif not (not arg_3_2.is_passive and arg_3_2.spawn_type == "horde" or arg_3_2.spawn_type == "horde_hidden") then
		if not action_data and not action_data.animations then
			local animations = action_data.animations
			local num = action_data.anim_cycle_index % #animations + 1

			str = animations[num]
			action_data.anim_cycle_index = num
		end
	elseif not action_data and not action_data.combat_animations then
		local combat_animations = action_data.combat_animations
		local num_2 = action_data.anim_cycle_index % #combat_animations + 1

		str = combat_animations[num_2]
		action_data.anim_cycle_index = num_2
	end

	local optional_spawn_data = arg_3_2.optional_spawn_data
	local flag = not optional_spawn_data and optional_spawn_data.idle_animation

	if not (not flag and flag == "") then
		str = flag
	end

	if arg_3_2.move_state ~= "idle" or not action_data or not action_data.force_idle_animation then
		network:anim_event(arg_3_1, str)

		arg_3_2.move_state = "idle"
	end

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

BTIdleAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.navigation_extension:set_enabled(true)
end

local function fn_2(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = POSITION_LOOKUP[arg_5_0]
	local ENEMY_PLAYER_POSITIONS = arg_5_2.ENEMY_PLAYER_POSITIONS

	for i = 1, #ENEMY_PLAYER_POSITIONS do
		local var_5_2 = ENEMY_PLAYER_POSITIONS[i]

		if arg_5_1 > Vector3.distance_squared(var_5_0, var_5_2) then
			return arg_5_2.ENEMY_PLAYER_UNITS[i]
		end
	end
end

BTIdleAction._discovery_sound_when_close = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local action = arg_6_2.action

	action = not action and arg_6_2.action.sound_when_near_distance_sqr

	if not (not action and arg_6_2.sound_when_near_played) then
		local var_6_1 = fn_2(arg_6_1, action, arg_6_2.side)

		if not var_6_1 then
			local network_id = Managers.player:unit_owner(var_6_1):network_id()
			local network = Managers.state.network
			local sound_when_near_event = arg_6_2.action.sound_when_near_event
			local var_6_5 = NetworkLookup.sound_events[sound_when_near_event]
			local unit_game_object_id = network:unit_game_object_id(arg_6_1)

			network.network_transmit:send_rpc("rpc_server_audio_unit_event", network_id, var_6_5, unit_game_object_id, false, 0)

			arg_6_2.sound_when_near_played = true
		end
	end
end

local alive = Unit.alive

BTIdleAction.run = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local target_unit = arg_7_2.target_unit
	local action = arg_7_2.action
	local flag = not action and action.dont_face_target

	if not (not alive(target_unit) and flag) then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, target_unit)

		arg_7_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
		self:_discovery_sound_when_close(arg_7_1, arg_7_2)
	end

	return "running"
end
