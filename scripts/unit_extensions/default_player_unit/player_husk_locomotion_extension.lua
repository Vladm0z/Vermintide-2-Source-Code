-- chunkname: @scripts/unit_extensions/default_player_unit/player_husk_locomotion_extension.lua

require("scripts/unit_extensions/default_player_unit/third_person_idle_fullbody_animation_control")

PlayerHuskLocomotionExtension = class(PlayerHuskLocomotionExtension)

local var_0_0 = POSITION_LOOKUP

function PlayerHuskLocomotionExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.game = arg_1_3.game
	arg_1_0.id = arg_1_3.id
	arg_1_0.player = arg_1_3.player
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.velocity_current = Vector3Box(0, 0, 0)
	arg_1_0._current_rotation = QuaternionBox(Quaternion.identity())
	arg_1_0.has_moved_from_start_position = arg_1_3.has_moved_from_start_position
	arg_1_0.anim_move_speed = 0
	arg_1_0.move_speed_anim_var = Unit.animation_find_variable(arg_1_2, "move_speed")

	Managers.player:assign_unit_ownership(arg_1_2, arg_1_0.player, true)

	local var_1_0 = LevelHelper:current_level_settings().on_spawn_flow_event

	if var_1_0 then
		Unit.flow_event(arg_1_2, var_1_0)
	end

	local var_1_1 = Unit.animation_find_variable(arg_1_2, "anim_run_speed")
	local var_1_2 = Unit.animation_find_variable(arg_1_2, "anim_walk_speed")

	arg_1_0.movement_scale_animation_id = Unit.animation_find_variable(arg_1_2, "movement_scale")
	arg_1_0.run_speed_treshold = Unit.animation_get_variable(arg_1_2, var_1_1)
	arg_1_0.walk_speed_treshold = Unit.animation_get_variable(arg_1_2, var_1_2)

	if arg_1_0.is_server then
		local var_1_3 = GwNavCostMap.create_tag_cost_table()

		AiUtils.initialize_nav_cost_map_cost_table(var_1_3, nil, 1)

		arg_1_0._latest_position_on_navmesh = Vector3Box(Unit.world_position(arg_1_2, 0))
		arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
		arg_1_0._nav_traverse_logic = GwNavTraverseLogic.create(arg_1_0._nav_world, var_1_3)
		arg_1_0._nav_cost_map_cost_table = var_1_3
	end

	arg_1_0.third_person_idle_fullbody_animation_control = ThirdPersonIdleFullbodyAnimationControl:new(arg_1_2)
end

function PlayerHuskLocomotionExtension.destroy(arg_2_0)
	if arg_2_0.is_server then
		GwNavCostMap.destroy_tag_cost_table(arg_2_0._nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(arg_2_0._nav_traverse_logic)
	end
end

function PlayerHuskLocomotionExtension.current_velocity(arg_3_0)
	return GameSession.game_object_field(arg_3_0.game, arg_3_0.id, "velocity")
end

function PlayerHuskLocomotionExtension.average_velocity(arg_4_0)
	return GameSession.game_object_field(arg_4_0.game, arg_4_0.id, "average_velocity")
end

function PlayerHuskLocomotionExtension.small_sample_size_average_velocity(arg_5_0)
	return GameSession.game_object_field(arg_5_0.game, arg_5_0.id, "small_sample_size_average_velocity")
end

function PlayerHuskLocomotionExtension.get_script_driven_gravity_scale(arg_6_0)
	return 1
end

function PlayerHuskLocomotionExtension.extensions_ready(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.status_extension = ScriptUnit.extension(arg_7_0.unit, "status_system")

	arg_7_0.third_person_idle_fullbody_animation_control:extensions_ready(arg_7_1, arg_7_2)
end

function PlayerHuskLocomotionExtension.add_external_velocity(arg_8_0, arg_8_1, arg_8_2)
	if not Managers.state.network:game() then
		return
	end

	local var_8_0 = arg_8_2 and "rpc_add_external_velocity_with_upper_limit" or "rpc_add_external_velocity"

	if arg_8_0.is_server then
		Managers.state.network.network_transmit:send_rpc(var_8_0, arg_8_0.player:network_id(), arg_8_0.id, arg_8_1, arg_8_2)
	else
		Managers.state.network.network_transmit:send_rpc_server(var_8_0, arg_8_0.id, arg_8_1, arg_8_2)
	end
end

function PlayerHuskLocomotionExtension.set_forced_velocity(arg_9_0, arg_9_1)
	if not arg_9_0.disabled then
		if arg_9_0.is_server or DEDICATED_SERVER then
			Managers.state.network.network_transmit:send_rpc("rpc_set_forced_velocity", arg_9_0.player:network_id(), arg_9_0.id, arg_9_1)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_forced_velocity", arg_9_0.id, arg_9_1)
		end
	end
end

function PlayerHuskLocomotionExtension.set_disabled(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0._disabled = arg_10_1
	arg_10_0._run_func = arg_10_2
	arg_10_0.master_unit = arg_10_3

	if not arg_10_1 then
		local var_10_0 = arg_10_0.unit
		local var_10_1 = var_0_0[var_10_0] or Unit.local_position(var_10_0, 0)

		arg_10_0._pos_lerp_time = 0

		Unit.set_data(var_10_0, "last_lerp_position", var_10_1)
		Unit.set_data(var_10_0, "last_lerp_position_offset", Vector3(0, 0, 0))
		Unit.set_data(var_10_0, "accumulated_movement", Vector3(0, 0, 0))

		local var_10_2 = Unit.mover(var_10_0)

		Mover.set_position(var_10_2, var_10_1)
		Unit.set_local_position(var_10_0, 0, var_10_1)
	end
end

function PlayerHuskLocomotionExtension.post_update(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	if arg_11_0._disabled then
		return
	end

	local var_11_0 = Managers.state.network:game()

	if var_11_0 and GameSession.game_object_exists(var_11_0, arg_11_0.id) then
		if HEALTH_ALIVE[arg_11_1] then
			local var_11_1 = "onground"

			arg_11_0:update_movement(arg_11_3, arg_11_1, var_11_1)
		end

		arg_11_0:_update_last_position_on_navmesh()
	end
end

function PlayerHuskLocomotionExtension.update(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	if arg_12_0._disabled then
		arg_12_0._run_func(arg_12_1, arg_12_3, arg_12_0)

		return
	end

	local var_12_0, var_12_1 = arg_12_0.status_extension:get_is_on_ladder()

	if var_12_0 and var_12_1 then
		arg_12_0:update_ladder_animation_position(var_12_1)
	end

	arg_12_0.third_person_idle_fullbody_animation_control:update(arg_12_5)
end

function PlayerHuskLocomotionExtension.last_position_on_navmesh(arg_13_0)
	assert(arg_13_0.is_server, "last position on nav mesh is only saved on server")

	return arg_13_0._latest_position_on_navmesh:unbox()
end

function PlayerHuskLocomotionExtension._update_last_position_on_navmesh(arg_14_0)
	if arg_14_0.is_server then
		local var_14_0 = GameSession.game_object_field(arg_14_0.game, arg_14_0.id, "position")
		local var_14_1, var_14_2 = GwNavQueries.triangle_from_position(arg_14_0._nav_world, var_14_0, 0.1, 0.3, arg_14_0._nav_traverse_logic)

		if var_14_1 then
			arg_14_0._latest_position_on_navmesh:store(Vector3(var_14_0.x, var_14_0.y, var_14_0.z))
		end
	end
end

local var_0_1 = 0.01
local var_0_2 = 0.1
local var_0_3 = 0.01
local var_0_4 = 1

function PlayerHuskLocomotionExtension.update_movement(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = Unit.local_position(arg_15_2, 0)
	local var_15_1
	local var_15_2 = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "linked_movement")
	local var_15_3 = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "moving_platform")

	if var_15_2 then
		local var_15_4 = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "link_parent_is_level_unit")
		local var_15_5 = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "link_parent_id")
		local var_15_6 = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "link_node")
		local var_15_7 = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "link_offset")
		local var_15_8 = Managers.state.network:game_object_or_level_unit(var_15_5, var_15_4)

		if Unit.alive(var_15_8) then
			var_15_1 = Unit.world_position(var_15_8, var_15_6) + var_15_7
		else
			var_15_1 = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "position")
		end
	else
		var_15_1 = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "position")
	end

	local var_15_9 = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "yaw")
	local var_15_10 = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "pitch")
	local var_15_11 = Quaternion(Vector3.up(), var_15_9)
	local var_15_12 = Quaternion(Vector3.right(), var_15_10)
	local var_15_13 = Quaternion.multiply(var_15_11, var_15_12)
	local var_15_14 = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "velocity")

	if Vector3.length(var_15_14) < NetworkConstants.VELOCITY_EPSILON then
		var_15_14 = Vector3(0, 0, 0)
	end

	arg_15_0.has_moved_from_start_position = GameSession.game_object_field(arg_15_0.game, arg_15_0.id, "has_moved_from_start_position")

	arg_15_0:_extrapolation_movement(arg_15_2, arg_15_1, var_15_0, var_15_1, var_15_13, arg_15_3, var_15_14, var_15_2, var_15_3)
	arg_15_0.velocity_current:store(var_15_14)
	arg_15_0._current_rotation:store(var_15_13)
	arg_15_0:_update_speed_variable(arg_15_1)
end

function PlayerHuskLocomotionExtension.get_moving_platform(arg_16_0)
	if not Managers.state.network:game() then
		return
	end

	if GameSession.game_object_exists(arg_16_0.game, arg_16_0.id) then
		local var_16_0 = GameSession.game_object_field(arg_16_0.game, arg_16_0.id, "moving_platform")
		local var_16_1 = var_16_0 ~= 0 and Managers.state.network:game_object_or_level_unit(var_16_0, true) or nil
		local var_16_2 = ScriptUnit.has_extension(var_16_1, "transportation_system")
		local var_16_3 = var_16_1 and GameSession.game_object_field(arg_16_0.game, arg_16_0.id, "moving_platform_soft_linked") or nil

		return var_16_1, var_16_2, var_16_3
	end

	return nil, nil, nil
end

function PlayerHuskLocomotionExtension.update_ladder_animation_position(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.unit
	local var_17_1 = Unit.world_position(arg_17_1, 0)
	local var_17_2 = CharacterStateHelper.time_in_ladder_move_animation(var_17_0, Vector3.z(var_17_1))
	local var_17_3 = Unit.animation_find_variable(var_17_0, "climb_time")

	Unit.animation_set_variable(var_17_0, var_17_3, var_17_2)
end

function PlayerHuskLocomotionExtension._extrapolation_movement(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9)
	local var_18_0 = Unit.get_data(arg_18_1, "last_lerp_position") or arg_18_3
	local var_18_1 = Unit.get_data(arg_18_1, "last_lerp_position_offset") or Vector3(0, 0, 0)
	local var_18_2 = Unit.get_data(arg_18_1, "accumulated_movement") or Vector3(0, 0, 0)

	if arg_18_0._moving_platform ~= arg_18_9 then
		local var_18_3 = (arg_18_0._moving_platform or 0) ~= 0 and Managers.state.network:game_object_or_level_unit(arg_18_0._moving_platform, true)
		local var_18_4 = arg_18_9 ~= 0 and Managers.state.network:game_object_or_level_unit(arg_18_9, true)

		if var_18_3 and var_18_4 then
			local var_18_5 = ScriptUnit.extension(var_18_3, "transportation_system")

			var_18_0 = var_18_0 + (Unit.local_position(var_18_3, 0) + var_18_5:visual_delta())

			local var_18_6 = ScriptUnit.extension(var_18_4, "transportation_system")

			var_18_0 = var_18_0 - (Unit.local_position(var_18_4, 0) + var_18_6:visual_delta())
		end

		arg_18_0._moving_platform = arg_18_9
	end

	if arg_18_9 ~= 0 and not arg_18_8 then
		local var_18_7 = Managers.state.network:game_object_or_level_unit(arg_18_9, true)
		local var_18_8 = Unit.local_position(var_18_7, 0)
		local var_18_9 = ScriptUnit.extension(var_18_7, "transportation_system")

		arg_18_4 = arg_18_4 + var_18_8 + var_18_9:visual_delta()
	end

	arg_18_0._pos_lerp_time = (arg_18_0._pos_lerp_time or 0) + arg_18_2
	arg_18_0._velocity_lerp_time = (arg_18_0._velocity_lerp_time or 0) + arg_18_2

	local var_18_10 = arg_18_8 and var_0_3 or var_0_2
	local var_18_11 = arg_18_0._pos_lerp_time / var_18_10
	local var_18_12 = arg_18_7 * arg_18_2
	local var_18_13 = var_18_2 + var_18_12
	local var_18_14 = Vector3.lerp(var_18_1, Vector3(0, 0, 0), math.min(var_18_11, 1))
	local var_18_15 = var_18_0 + var_18_13 + var_18_14

	Profiler.record_statistics("move_delta", Vector3.length(var_18_12))
	Profiler.record_statistics("husk_speed", Vector3.length(arg_18_7))
	Profiler.record_statistics("dt", arg_18_2)
	Unit.set_data(arg_18_1, "accumulated_movement", var_18_13)

	if Vector3.length(arg_18_4 - var_18_0) > var_0_1 then
		arg_18_0._pos_lerp_time = 0

		Unit.set_data(arg_18_1, "last_lerp_position", arg_18_4)
		Unit.set_data(arg_18_1, "last_lerp_position_offset", var_18_15 - arg_18_4)
		Unit.set_data(arg_18_1, "accumulated_movement", Vector3(0, 0, 0))
	end

	local var_18_16 = arg_18_0.velocity_current:unbox()

	if Vector3.length(arg_18_7 - var_18_16) > NetworkConstants.VELOCITY_EPSILON then
		arg_18_0._velocity_lerp_time = 0
	end

	if arg_18_0._pos_lerp_time > var_0_4 and arg_18_0._velocity_lerp_time > var_0_4 then
		var_18_15 = arg_18_4

		Unit.set_data(arg_18_1, "accumulated_movement", Vector3(0, 0, 0))
	end

	local var_18_17 = Unit.mover(arg_18_1)

	Mover.set_position(var_18_17, var_18_15)
	Unit.set_local_position(arg_18_1, 0, var_18_15)

	local var_18_18 = Unit.local_rotation(arg_18_1, 0)

	Unit.set_local_rotation(arg_18_1, 0, Quaternion.lerp(var_18_18, arg_18_5, math.min(arg_18_2 * 15, 1)))
end

local var_0_5 = 0.97
local var_0_6 = 3.23
local var_0_7 = 6.14
local var_0_8 = 0.3
local var_0_9 = 1.5
local var_0_10 = 99.9999
local var_0_11 = 0.3

function PlayerHuskLocomotionExtension._update_speed_variable(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.velocity_current:unbox()
	local var_19_1 = Vector3(var_19_0.x, var_19_0.y, 0)
	local var_19_2 = Vector3.length(var_19_1)
	local var_19_3 = arg_19_0.anim_move_speed
	local var_19_4 = math.abs(var_19_3 - var_19_2)

	if var_19_3 < var_19_2 then
		local var_19_5 = math.min(var_19_2 / var_0_11 * arg_19_1, var_19_4)

		var_19_3 = math.clamp(var_19_3 + var_19_5, 0, var_19_2)
		arg_19_0._move_speed_top = var_19_3
	else
		local var_19_6 = arg_19_0._move_speed_top or var_19_2
		local var_19_7 = math.min(var_19_6 / var_0_11 * arg_19_1, var_19_4)

		var_19_3 = math.clamp(var_19_3 - var_19_7, 0, var_19_3)
	end

	arg_19_0.anim_move_speed = var_19_3

	local var_19_8 = arg_19_0.unit

	Unit.animation_set_variable(var_19_8, arg_19_0.move_speed_anim_var, math.min(var_19_3, var_0_10))

	local var_19_9

	if var_19_2 < arg_19_0.walk_speed_treshold then
		var_19_9 = var_19_2 / arg_19_0.walk_speed_treshold
	elseif var_19_2 > arg_19_0.run_speed_treshold then
		var_19_9 = var_19_2 / arg_19_0.run_speed_treshold
	else
		var_19_9 = 1
	end

	local var_19_10 = math.clamp(var_19_9, var_0_8, var_0_9)

	Unit.animation_set_variable(var_19_8, arg_19_0.movement_scale_animation_id, var_19_10)
end

function PlayerHuskLocomotionExtension._calculate_move_speed_var_from_mps(arg_20_0, arg_20_1)
	local var_20_0
	local var_20_1 = 1

	if arg_20_1 <= var_0_5 then
		var_20_0 = 0
		var_20_1 = arg_20_1 / var_0_5
	elseif arg_20_1 <= var_0_6 then
		var_20_0 = (arg_20_1 - var_0_5) / (var_0_6 - var_0_5)
	elseif arg_20_1 <= var_0_7 then
		var_20_0 = 1 + (arg_20_1 - var_0_6) / (var_0_7 - var_0_6)
	else
		var_20_0 = 3
		var_20_1 = arg_20_1 / var_0_7
	end

	return var_20_0, var_20_1
end

function PlayerHuskLocomotionExtension.rpc_animation_set_variable(arg_21_0, arg_21_1, arg_21_2)
	Unit.animation_set_variable(arg_21_0.unit, arg_21_1, arg_21_2)
end

function PlayerHuskLocomotionExtension.hot_join_sync(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.unit

	if Managers.state.unit_spawner:is_marked_for_deletion(var_22_0) then
		return
	end

	local var_22_1 = arg_22_0.id
	local var_22_2 = PEER_ID_TO_CHANNEL[arg_22_1]

	RPC.rpc_sync_anim_state_3(var_22_2, var_22_1, Unit.animation_get_state(var_22_0))
end

function PlayerHuskLocomotionExtension.current_rotation(arg_23_0)
	return arg_23_0._current_rotation:unbox()
end

local var_0_12 = 1

function PlayerHuskLocomotionExtension.move_to_non_intersecting_position(arg_24_0)
	local var_24_0 = arg_24_0.unit
	local var_24_1 = Unit.mover(var_24_0)
	local var_24_2, var_24_3, var_24_4, var_24_5 = Mover.separate(var_24_1, var_0_12)

	if var_24_2 and var_24_5 then
		Mover.set_position(var_24_1, var_24_5)
		Unit.set_local_position(var_24_0, 0, var_24_5)
	end
end

function PlayerHuskLocomotionExtension.teleport_to(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0.unit
	local var_25_1 = Unit.mover(var_25_0)

	Mover.set_position(var_25_1, arg_25_1)
	Unit.set_local_position(var_25_0, 0, arg_25_1)

	if arg_25_2 then
		Unit.set_local_rotation(var_25_0, 0, arg_25_2)
	end

	arg_25_0:move_to_non_intersecting_position()
end
