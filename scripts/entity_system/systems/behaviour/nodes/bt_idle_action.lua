-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTIdleAction = class(BTIdleAction, BTNode)

function BTIdleAction.init(arg_1_0, ...)
	BTIdleAction.super.init(arg_1_0, ...)
end

BTIdleAction.name = "BTIdleAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

function BTIdleAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = Managers.state.network
	local var_3_1 = "idle"
	local var_3_2 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_2
	arg_3_2.spawn_to_running = nil

	if var_3_2 and var_3_2.alerted_anims and arg_3_2.confirmed_player_sighting then
		var_3_1 = var_3_2.alerted_anims[math.random(1, #var_3_2.alerted_anims)]
	elseif var_3_2 and var_3_2.idle_combat and not arg_3_2.is_passive then
		var_3_1 = var_0_0(var_3_2.idle_combat)
	elseif var_3_2 and var_3_2.idle_animation then
		var_3_1 = var_0_0(var_3_2.idle_animation)
	elseif arg_3_2.is_passive and arg_3_2.spawn_type ~= "horde" and arg_3_2.spawn_type ~= "horde_hidden" then
		if var_3_2 and var_3_2.animations then
			local var_3_3 = var_3_2.animations
			local var_3_4 = var_3_2.anim_cycle_index % #var_3_3 + 1

			var_3_1 = var_3_3[var_3_4]
			var_3_2.anim_cycle_index = var_3_4
		end
	elseif var_3_2 and var_3_2.combat_animations then
		local var_3_5 = var_3_2.combat_animations
		local var_3_6 = var_3_2.anim_cycle_index % #var_3_5 + 1

		var_3_1 = var_3_5[var_3_6]
		var_3_2.anim_cycle_index = var_3_6
	end

	local var_3_7 = arg_3_2.optional_spawn_data
	local var_3_8 = var_3_7 and var_3_7.idle_animation

	if var_3_8 and var_3_8 ~= "" then
		var_3_1 = var_3_8
	end

	if arg_3_2.move_state ~= "idle" or var_3_2 and var_3_2.force_idle_animation then
		var_3_0:anim_event(arg_3_1, var_3_1)

		arg_3_2.move_state = "idle"
	end

	arg_3_2.navigation_extension:set_enabled(false)
	arg_3_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
end

function BTIdleAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.navigation_extension:set_enabled(true)
end

local function var_0_1(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = POSITION_LOOKUP[arg_5_0]
	local var_5_1 = arg_5_2.ENEMY_PLAYER_POSITIONS

	for iter_5_0 = 1, #var_5_1 do
		local var_5_2 = var_5_1[iter_5_0]

		if arg_5_1 > Vector3.distance_squared(var_5_0, var_5_2) then
			return arg_5_2.ENEMY_PLAYER_UNITS[iter_5_0]
		end
	end
end

function BTIdleAction._discovery_sound_when_close(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.action and arg_6_2.action.sound_when_near_distance_sqr

	if var_6_0 and not arg_6_2.sound_when_near_played then
		local var_6_1 = var_0_1(arg_6_1, var_6_0, arg_6_2.side)

		if var_6_1 then
			local var_6_2 = Managers.player:unit_owner(var_6_1):network_id()
			local var_6_3 = Managers.state.network
			local var_6_4 = arg_6_2.action.sound_when_near_event
			local var_6_5 = NetworkLookup.sound_events[var_6_4]
			local var_6_6 = var_6_3:unit_game_object_id(arg_6_1)

			var_6_3.network_transmit:send_rpc("rpc_server_audio_unit_event", var_6_2, var_6_5, var_6_6, false, 0)

			arg_6_2.sound_when_near_played = true
		end
	end
end

local var_0_2 = Unit.alive

function BTIdleAction.run(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_2.target_unit
	local var_7_1 = arg_7_2.action
	local var_7_2 = var_7_1 and var_7_1.dont_face_target

	if var_0_2(var_7_0) and not var_7_2 then
		local var_7_3 = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, var_7_0)

		arg_7_2.locomotion_extension:set_wanted_rotation(var_7_3)
		arg_7_0:_discovery_sound_when_close(arg_7_1, arg_7_2)
	end

	return "running"
end
