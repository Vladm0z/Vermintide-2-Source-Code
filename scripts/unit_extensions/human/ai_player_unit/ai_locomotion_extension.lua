-- chunkname: @scripts/unit_extensions/human/ai_player_unit/ai_locomotion_extension.lua

require("scripts/helpers/mover_helper")

local var_0_0 = Unit.local_position
local var_0_1 = 10
local var_0_2 = 20
local var_0_3 = 0.5

AILocomotionExtension = class(AILocomotionExtension)

AILocomotionExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._system_data = arg_1_3.system_data
	arg_1_0._unit = arg_1_2
	arg_1_0.breed = arg_1_3.breed
	arg_1_0._world = arg_1_1.world
	arg_1_0._nav_world = arg_1_3.nav_world

	assert(arg_1_0._nav_world)

	arg_1_0._move_speed_var = Unit.animation_find_variable(arg_1_2, "move_speed")
	arg_1_0._velocity = Vector3Box()
	arg_1_0._update_function_name = "update_script_driven"
	arg_1_0._wanted_velocity = nil
	arg_1_0._wanted_rotation = nil
	arg_1_0._rotation_speed = var_0_1
	arg_1_0._rotation_speed_modifier = 1
	arg_1_0._infinite_rotation_speed = false
	arg_1_0._affected_by_gravity = true
	arg_1_0._constrained_by_mover = false
	arg_1_0._constrained_by_players = false
	arg_1_0._snap_to_navmesh = true
	arg_1_0._animation_translation_scale_box = Vector3Box(1, 1, 1)
	arg_1_0._animation_rotation_scale = 1
	arg_1_0._lerp_rotation = true
	arg_1_0._is_falling = false
	arg_1_0._check_falling = true
	arg_1_0._gravity = var_0_2
	arg_1_0.move_speed = 0
	arg_1_0._system_data.all_update_units[arg_1_0._unit] = arg_1_0

	Unit.set_animation_merge_options(arg_1_2)

	arg_1_0.is_server = Managers.player.is_server
	arg_1_0._last_fall_position = Vector3Box(10000, 10000, 10000)
	arg_1_0._mover_state = MoverHelper.create_mover_state()

	local var_1_0 = "c_mover_collision"

	if Unit.actor(arg_1_2, var_1_0) then
		arg_1_0._collision_state = MoverHelper.create_collision_state(arg_1_2, var_1_0)
	end

	MoverHelper.set_active_mover(arg_1_2, arg_1_0._mover_state, arg_1_0.breed.default_mover or "mover")
	arg_1_0:set_movement_type("snap_to_navmesh")
end

AILocomotionExtension.destroy = function (arg_2_0)
	local var_2_0 = arg_2_0._system_data
	local var_2_1 = arg_2_0._unit

	var_2_0.destroy_units[var_2_1] = arg_2_0
end

AILocomotionExtension.ready = function (arg_3_0, arg_3_1, arg_3_2)
	return
end

AILocomotionExtension.hot_join_sync = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._unit

	if FROZEN[var_4_0] then
		return
	end

	local var_4_1 = PEER_ID_TO_CHANNEL[arg_4_1]

	if Unit.has_animation_state_machine(var_4_0) then
		local var_4_2 = Managers.state.network:unit_game_object_id(var_4_0)
		local var_4_3 = Unit.get_data(var_4_0, "breed")

		RPC[var_4_3.animation_sync_rpc](var_4_1, var_4_2, Unit.animation_get_state(var_4_0))
	else
		local var_4_4 = Managers.state.network:unit_game_object_id(var_4_0)

		RPC.rpc_hot_join_nail_to_wall_fix(var_4_1, var_4_4)
	end
end

AILocomotionExtension.set_mover_displacement = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_1 then
		local var_5_0 = Unit.mover(arg_5_0._unit)

		Mover.move(var_5_0, arg_5_1, 0.00390625)

		arg_5_0._mover_displacement_duration = arg_5_2
		arg_5_0._mover_displacement = Vector3Box(arg_5_1)
		arg_5_0._mover_displacement_t = arg_5_2
	else
		arg_5_0._mover_displacement = Vector3Box(0, 0, 0)
		arg_5_0._mover_displacement_duration = nil
		arg_5_0._mover_displacement_t = nil
	end
end

AILocomotionExtension.teleport_to = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._unit

	Unit.set_local_position(var_6_0, 0, arg_6_1)

	if arg_6_2 then
		Unit.set_local_rotation(var_6_0, 0, arg_6_2)
	end

	local var_6_1 = Managers.state.network
	local var_6_2 = var_6_1:game()

	if var_6_2 then
		local var_6_3 = var_6_1:unit_game_object_id(var_6_0)
		local var_6_4 = GameSession.game_object_field(var_6_2, var_6_3, "has_teleported") % NetworkConstants.teleports.max + 1

		GameSession.set_game_object_field(var_6_2, var_6_3, "has_teleported", var_6_4)
	end
end

local var_0_4 = "update_animation_driven_movement_script_driven_rotation"
local var_0_5 = "update_animation_driven"
local var_0_6 = "update_script_driven"
local var_0_7 = "update_linked_transport"

AILocomotionExtension.set_animation_driven = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	arg_7_2 = arg_7_2 or false

	local var_7_0 = arg_7_0._unit

	arg_7_0:set_affected_by_gravity(arg_7_2)

	local var_7_1 = Managers.state.network
	local var_7_2 = var_7_1.network_transmit
	local var_7_3 = var_7_1:game() and var_7_1:unit_game_object_id(var_7_0)

	if not var_7_3 then
		return
	end

	local var_7_4 = arg_7_0._update_function_name
	local var_7_5 = arg_7_0._affected_by_gravity
	local var_7_6 = var_7_4 == var_0_5
	local var_7_7 = var_7_4 == var_0_4
	local var_7_8 = var_7_4 == var_0_6
	local var_7_9 = var_7_4 == var_0_7
	local var_7_10 = false
	local var_7_11 = arg_7_0._system_data

	if arg_7_4 then
		if not var_7_9 then
			arg_7_0._update_function_name = var_0_7
			var_7_11.animation_update_units[var_7_0] = nil
			var_7_11.animation_and_script_update_units[var_7_0] = nil

			var_7_2:send_rpc_clients("rpc_set_linked_transport_driven", var_7_3, arg_7_2)
		end

		var_7_10 = true
	elseif arg_7_1 and arg_7_3 and not var_7_7 then
		arg_7_0._update_function_name = var_0_4
		var_7_11.animation_update_units[var_7_0] = nil
		var_7_11.animation_and_script_update_units[var_7_0] = arg_7_0

		if var_7_3 then
			local var_7_12 = Unit.local_position(var_7_0, 0)
			local var_7_13 = Unit.local_rotation(var_7_0, 0)

			var_7_2:send_rpc_clients("rpc_set_animation_driven_script_movement", var_7_3, var_7_12, var_7_13, arg_7_2)
		end

		var_7_10 = true
	elseif arg_7_1 and not arg_7_3 and not var_7_6 then
		arg_7_0._update_function_name = var_0_5
		var_7_11.animation_update_units[var_7_0] = arg_7_0
		var_7_11.animation_and_script_update_units[var_7_0] = nil

		if var_7_3 then
			local var_7_14 = Unit.local_position(var_7_0, 0)
			local var_7_15 = Unit.local_rotation(var_7_0, 0)

			var_7_2:send_rpc_clients("rpc_set_animation_driven", var_7_3, var_7_14, var_7_15, arg_7_2)
		end

		var_7_10 = true
	elseif not arg_7_1 and not var_7_8 then
		arg_7_0._update_function_name = var_0_6
		var_7_11.animation_update_units[var_7_0] = nil
		var_7_11.animation_and_script_update_units[var_7_0] = nil

		if var_7_3 then
			var_7_2:send_rpc_clients("rpc_set_script_driven", var_7_3, arg_7_2)
		end

		var_7_10 = true
	end

	if var_7_3 and not var_7_10 and var_7_5 ~= arg_7_2 then
		var_7_2:send_rpc_clients("rpc_set_affected_by_gravity", var_7_3, arg_7_2)
	end
end

AILocomotionExtension.set_animation_translation_scale = function (arg_8_0, arg_8_1)
	arg_8_0._animation_translation_scale_box:store(arg_8_1)
end

AILocomotionExtension.set_animation_rotation_scale = function (arg_9_0, arg_9_1)
	arg_9_0._animation_rotation_scale = arg_9_1
end

AILocomotionExtension.set_wanted_velocity_flat = function (arg_10_0, arg_10_1)
	arg_10_1.z = arg_10_0._velocity.z
	arg_10_0._wanted_velocity = arg_10_1
end

AILocomotionExtension.set_wanted_velocity = function (arg_11_0, arg_11_1)
	arg_11_0._wanted_velocity = arg_11_1

	arg_11_0._velocity:store(arg_11_1)
end

AILocomotionExtension.set_wanted_rotation = function (arg_12_0, arg_12_1)
	arg_12_0._wanted_rotation = arg_12_1
end

AILocomotionExtension.use_lerp_rotation = function (arg_13_0, arg_13_1)
	arg_13_0._lerp_rotation = arg_13_1
end

AILocomotionExtension.set_rotation_speed = function (arg_14_0, arg_14_1)
	if arg_14_1 == nil then
		arg_14_0._rotation_speed = var_0_1
	else
		arg_14_0._rotation_speed = arg_14_1
	end
end

AILocomotionExtension.set_rotation_speed_modifier = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_0._system_data.rotation_speed_modifier_update_units[arg_15_0._unit] = arg_15_0
	arg_15_0._rotation_speed_modifier = arg_15_1
	arg_15_0._rotation_speed_modifier_lerp_start_value = arg_15_1
	arg_15_0._rotation_speed_modifier_lerp_start_time = arg_15_3
	arg_15_0._rotation_speed_modifier_lerp_end_time = arg_15_3 + arg_15_2
end

AILocomotionExtension.set_affected_by_gravity = function (arg_16_0, arg_16_1)
	arg_16_0._affected_by_gravity = arg_16_1

	if arg_16_1 and arg_16_0._system_data.snap_to_navmesh_update_units[arg_16_0._unit] == nil then
		arg_16_0._system_data.affected_by_gravity_update_units[arg_16_0._unit] = arg_16_0
	elseif not arg_16_1 then
		arg_16_0._system_data.affected_by_gravity_update_units[arg_16_0._unit] = nil
	end
end

AILocomotionExtension.set_gravity = function (arg_17_0, arg_17_1)
	arg_17_0._gravity = arg_17_1 or var_0_2
end

AILocomotionExtension.set_mover_disable_reason = function (arg_18_0, arg_18_1, arg_18_2)
	MoverHelper.set_disable_reason(arg_18_0._unit, arg_18_0._mover_state, arg_18_1, arg_18_2)
end

AILocomotionExtension.set_check_falling = function (arg_19_0, arg_19_1)
	arg_19_0._check_falling = arg_19_1
end

AILocomotionExtension.set_collision_disabled = function (arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0._collision_state then
		MoverHelper.set_collision_disable_reason(arg_20_0._unit, arg_20_0._collision_state, arg_20_1, arg_20_2)
	end
end

AILocomotionExtension.set_movement_type = function (arg_21_0, arg_21_1, arg_21_2)
	if arg_21_1 == arg_21_0.movement_type then
		return
	end

	arg_21_0.movement_type = arg_21_1

	local var_21_0 = arg_21_0._unit

	if arg_21_1 == "script_driven" then
		arg_21_0._snap_to_navmesh = false
		arg_21_0._constrained_by_mover = false
		arg_21_0._system_data.script_driven_update_units[var_21_0] = arg_21_0
		arg_21_0._system_data.snap_to_navmesh_update_units[var_21_0] = nil
		arg_21_0._system_data.get_to_navmesh_update_units[var_21_0] = nil
		arg_21_0._system_data.mover_constrained_update_units[var_21_0] = nil
		arg_21_0._system_data.affected_by_gravity_update_units[var_21_0] = arg_21_0._affected_by_gravity and arg_21_0 or nil

		MoverHelper.set_disable_reason(var_21_0, arg_21_0._mover_state, "constrained_by_mover", true)
	elseif arg_21_1 == "snap_to_navmesh" then
		local var_21_1 = var_0_0(var_21_0, 0)
		local var_21_2, var_21_3 = GwNavQueries.triangle_from_position(arg_21_0._nav_world, var_21_1, 0.5, 0.5)

		if var_21_2 then
			arg_21_0._system_data.snap_to_navmesh_update_units[var_21_0] = arg_21_0
			arg_21_0._system_data.get_to_navmesh_update_units[var_21_0] = nil
		else
			arg_21_0._system_data.get_to_navmesh_update_units[var_21_0] = arg_21_0
			arg_21_0._system_data.snap_to_navmesh_update_units[var_21_0] = nil
		end

		arg_21_0._snap_to_navmesh = true
		arg_21_0._constrained_by_mover = false
		arg_21_0._system_data.script_driven_update_units[var_21_0] = nil
		arg_21_0._system_data.mover_constrained_update_units[var_21_0] = nil
		arg_21_0._system_data.affected_by_gravity_update_units[var_21_0] = nil

		MoverHelper.set_disable_reason(var_21_0, arg_21_0._mover_state, "constrained_by_mover", true)
	elseif arg_21_1 == "constrained_by_mover" then
		arg_21_0._snap_to_navmesh = false
		arg_21_0._constrained_by_mover = true
		arg_21_0._system_data.script_driven_update_units[var_21_0] = nil
		arg_21_0._system_data.snap_to_navmesh_update_units[var_21_0] = nil
		arg_21_0._system_data.get_to_navmesh_update_units[var_21_0] = nil
		arg_21_0._system_data.mover_constrained_update_units[var_21_0] = arg_21_0
		arg_21_0._system_data.affected_by_gravity_update_units[var_21_0] = arg_21_0._affected_by_gravity and arg_21_0 or nil

		MoverHelper.set_disable_reason(var_21_0, arg_21_0._mover_state, "constrained_by_mover", false)

		local var_21_4 = Unit.mover(var_21_0)
		local var_21_5 = arg_21_2 or var_0_3
		local var_21_6, var_21_7, var_21_8, var_21_9 = Mover.separate(var_21_4, var_21_5)

		if var_21_6 then
			if var_21_9 then
				Mover.set_position(var_21_4, var_21_9)
			else
				local var_21_10 = "forced"
				local var_21_11 = Vector3(0, 0, -1)

				AiUtils.kill_unit(var_21_0, nil, nil, var_21_10, var_21_11)

				return
			end
		end

		local var_21_12 = Mover.position(var_21_4)

		Unit.set_local_position(var_21_0, 0, var_21_12)

		local var_21_13 = World.get_data(arg_21_0._world, "physics_world")
		local var_21_14 = 0.5
		local var_21_15 = 1.5
		local var_21_16 = Vector3(var_21_14, var_21_15, var_21_14)
		local var_21_17 = Quaternion.look(Vector3(0, 0, 1))
		local var_21_18 = var_21_15 - var_21_14 > 0 and "capsule" or "sphere"
		local var_21_19, var_21_20 = PhysicsWorld.immediate_overlap(var_21_13, "shape", var_21_18, "position", var_21_12, "rotation", var_21_17, "size", var_21_16, "collision_filter", "filter_environment_overlap")

		arg_21_0._is_falling = var_21_20 == 0
	end
end

AILocomotionExtension.set_disabled = function (arg_22_0)
	assert(not arg_22_0._disabled, "ai_locomotion_extension disabled extension several times.")

	arg_22_0._system_data.destroy_units[unit] = arg_22_0

	MoverHelper.set_disable_reason(unit, arg_22_0._mover_state, "constrained_by_mover", true)

	arg_22_0._disabled = true
end

AILocomotionExtension.current_velocity = function (arg_23_0)
	return arg_23_0._velocity:unbox()
end

AILocomotionExtension.is_falling = function (arg_24_0)
	return arg_24_0._is_falling
end

AILocomotionExtension.get_rotation_speed = function (arg_25_0)
	return arg_25_0._rotation_speed
end

AILocomotionExtension.get_rotation_speed_modifier = function (arg_26_0)
	return arg_26_0._rotation_speed_modifier
end

AILocomotionExtension.get_animation_rotation_scale = function (arg_27_0)
	return arg_27_0._animation_rotation_scale
end

AILocomotionExtension.get_animation_translation_scale = function (arg_28_0)
	return arg_28_0._animation_translation_scale_box:unbox()
end
