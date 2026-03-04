-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_locomotion_extension.lua

require("scripts/helpers/mover_helper")
require("scripts/unit_extensions/default_player_unit/third_person_idle_fullbody_animation_control")

PlayerUnitLocomotionExtension = class(PlayerUnitLocomotionExtension)

local var_0_0 = POSITION_LOOKUP
local var_0_1 = 99.9999
local var_0_2 = 0.15

function PlayerUnitLocomotionExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.player = arg_1_3.player

	local var_1_0 = arg_1_0.player:profile_index()

	arg_1_0._default_mover_filter = SPProfiles[var_1_0].mover_profile or "filter_player_mover"
	arg_1_0._pactsworn_no_clip = arg_1_0._default_mover_filter == "filter_player_mover_pactsworn"
	arg_1_0._no_clip_filter = {}
	arg_1_0.velocity_network = Vector3Box()
	arg_1_0.velocity_current = Vector3Box()
	arg_1_0.animation_translation_scale = Vector3Box(1, 1, 1)
	arg_1_0.external_velocity = nil
	arg_1_0._external_velocity_enabled = true
	arg_1_0._script_driven_gravity_scale = 1
	arg_1_0._velocity_forced = Vector3Box()
	arg_1_0._dirty_forced_velocity = false
	arg_1_0.use_drag = true

	arg_1_0:reset()

	arg_1_0.anim_move_speed = 0
	arg_1_0.move_speed_anim_var = Unit.animation_find_variable(arg_1_2, "move_speed")
	arg_1_0.collides_down = true
	arg_1_0.on_ground = true
	arg_1_0.time_since_last_down_collide = 0
	arg_1_0.rotate_along_direction = true
	arg_1_0.debugging_animations = false
	arg_1_0.ignore_gravity = false

	arg_1_0:_initialize_sample_velocities()

	arg_1_0.mover_state = MoverHelper.create_mover_state()

	MoverHelper.set_active_mover(arg_1_2, arg_1_0.mover_state, "standing")

	arg_1_0.world = arg_1_1.world
	arg_1_0.is_bot = arg_1_3.player.bot_player

	local var_1_1 = Unit.local_rotation(arg_1_2, 0)

	arg_1_0.target_rotation = QuaternionBox(var_1_1)

	arg_1_0:move_to_non_intersecting_position()

	local var_1_2 = Unit.world_position(arg_1_2, 0)

	arg_1_0.has_moved_from_start_position = false
	arg_1_0._start_position = Vector3Box(var_1_2)

	if arg_1_0.is_server then
		local var_1_3 = GwNavCostMap.create_tag_cost_table()

		AiUtils.initialize_nav_cost_map_cost_table(var_1_3, nil, 1)

		arg_1_0._latest_position_on_navmesh = Vector3Box(var_1_2)
		arg_1_0._nav_world = Managers.state.entity:system("ai_system"):nav_world()
		arg_1_0._nav_traverse_logic = GwNavTraverseLogic.create(arg_1_0._nav_world, var_1_3)
		arg_1_0._nav_cost_map_cost_table = var_1_3
	end

	arg_1_0._system_data = arg_1_3.system_data
	arg_1_0._system_data.all_update_units[arg_1_2] = arg_1_0
	arg_1_0._mover_modes = {
		ladder = false,
		enemy_noclip = false,
		dark_pact_noclip = false,
		enemy_leap_state = false
	}
	arg_1_0._climb_entrance = nil
	arg_1_0._climb_exit = nil
	arg_1_0.wanted_position = Vector3Box()
	arg_1_0.third_person_idle_fullbody_animation_control = ThirdPersonIdleFullbodyAnimationControl:new(arg_1_2)
end

function PlayerUnitLocomotionExtension.set_mover_filter_property(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0._mover_modes

	fassert(arg_2_2 ~= nil, "Trying to set mover filter property nil")
	fassert(var_2_0[arg_2_1] ~= nil, "Trying to set unitialized mover filter property %q.", arg_2_2)

	var_2_0[arg_2_1] = arg_2_2

	local var_2_1
	local var_2_2 = var_2_0.ladder and "filter_player_ladder_mover" or var_2_0.enemy_noclip and "filter_player_enemy_noclip_mover" or var_2_0.dark_pact_noclip and "filter_player_mover_pactsworn_ghost_mode" or var_2_0.enemy_leap_state and "filter_player_enemy_leap_state_noclip_mover" or arg_2_0._default_mover_filter
	local var_2_3 = Unit.mover(arg_2_0.unit)

	Mover.set_collision_filter(var_2_3, var_2_2)
end

local var_0_3 = 1

function PlayerUnitLocomotionExtension.move_to_non_intersecting_position(arg_3_0)
	local var_3_0 = arg_3_0.unit
	local var_3_1 = Unit.mover(var_3_0)
	local var_3_2, var_3_3, var_3_4, var_3_5 = Mover.separate(var_3_1, var_0_3)

	if var_3_2 and var_3_5 then
		Mover.set_position(var_3_1, var_3_5)
		Unit.set_local_position(var_3_0, 0, var_3_5)
	end
end

function PlayerUnitLocomotionExtension.destroy(arg_4_0)
	if arg_4_0.is_server then
		GwNavCostMap.destroy_tag_cost_table(arg_4_0._nav_cost_map_cost_table)
		GwNavTraverseLogic.destroy(arg_4_0._nav_traverse_logic)
	end

	local var_4_0 = arg_4_0.unit
	local var_4_1 = arg_4_0._system_data

	var_4_1.all_disabled_units[var_4_0] = nil
	var_4_1.all_update_units[var_4_0] = nil
end

function PlayerUnitLocomotionExtension.set_on_moving_platform(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0

	if arg_5_1 then
		arg_5_0._platform_extension = ScriptUnit.extension(arg_5_1, "transportation_system")
		arg_5_0._platform_unit = arg_5_1
		arg_5_0._soft_platform = arg_5_2
		var_5_0 = Managers.state.network:level_object_id(arg_5_1)
	else
		arg_5_0._platform_extension = nil
		arg_5_0._platform_unit = nil
		arg_5_0._soft_platform = nil
		var_5_0 = 0
	end

	local var_5_1 = Managers.state.network:game()
	local var_5_2 = Managers.state.unit_storage:go_id(arg_5_0.unit)

	GameSession.set_game_object_field(var_5_1, var_5_2, "moving_platform", var_5_0)
	GameSession.set_game_object_field(var_5_1, var_5_2, "moving_platform_soft_linked", arg_5_2 or false)
	arg_5_0:sync_network_position(var_5_1, var_5_2)
end

function PlayerUnitLocomotionExtension.get_moving_platform(arg_6_0)
	return arg_6_0._platform_unit, arg_6_0._platform_extension, arg_6_0._soft_platform
end

function PlayerUnitLocomotionExtension.hot_join_sync(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.unit
	local var_7_1 = Managers.state.network:unit_game_object_id(var_7_0)
	local var_7_2 = PEER_ID_TO_CHANNEL[arg_7_1]

	RPC.rpc_sync_anim_state_3(var_7_2, var_7_1, Unit.animation_get_state(var_7_0))
end

function PlayerUnitLocomotionExtension._initialize_sample_velocities(arg_8_0)
	arg_8_0._sample_velocity_index = 0
	arg_8_0._sample_velocity_time = Managers.time:time("game")
	arg_8_0._average_velocity = Vector3Box(0, 0, 0)
	arg_8_0._small_sample_size_average_velocity = Vector3Box(0, 0, 0)
	arg_8_0._sample_velocities = {
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0),
		Vector3Box(0, 0, 0)
	}
end

function PlayerUnitLocomotionExtension._stop(arg_9_0, arg_9_1)
	local var_9_0 = Vector3.zero()

	arg_9_0.velocity_current:store(var_9_0)
	arg_9_0.velocity_network:store(var_9_0)

	if arg_9_1 then
		local var_9_1 = arg_9_0._sample_velocities

		for iter_9_0 = 1, #var_9_1 do
			var_9_1[iter_9_0]:store(var_9_0)
		end
	end
end

function PlayerUnitLocomotionExtension.average_velocity(arg_10_0)
	return arg_10_0._average_velocity:unbox()
end

function PlayerUnitLocomotionExtension.small_sample_size_average_velocity(arg_11_0)
	return arg_11_0._small_sample_size_average_velocity:unbox()
end

function PlayerUnitLocomotionExtension.extensions_ready(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0.first_person_extension = ScriptUnit.extension(arg_12_0.unit, "first_person_system")
	arg_12_0.status_extension = ScriptUnit.extension(arg_12_0.unit, "status_system")

	arg_12_0.third_person_idle_fullbody_animation_control:extensions_ready(arg_12_1, arg_12_2)
end

function PlayerUnitLocomotionExtension.last_position_on_navmesh(arg_13_0)
	assert(arg_13_0.is_server, "last position on nav mesh is only saved on server")

	return arg_13_0._latest_position_on_navmesh:unbox()
end

function PlayerUnitLocomotionExtension.reset(arg_14_0)
	arg_14_0.state = "script_driven"
	arg_14_0.velocity_wanted = Vector3Box(0, 0, 0)
	arg_14_0.allow_jump = false

	arg_14_0:reset_maximum_upwards_velocity()

	arg_14_0.speed_multiplier = nil
	arg_14_0.speed_multiplier_start_time = nil
	arg_14_0.speed_multiplier_duration = nil
end

function PlayerUnitLocomotionExtension.set_disabled(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	arg_15_0.disabled = arg_15_1
	arg_15_0.run_func = arg_15_2
	arg_15_0.master_unit = arg_15_3

	local var_15_0 = arg_15_0._system_data
	local var_15_1 = arg_15_0.unit

	if arg_15_1 then
		var_15_0.all_update_units[var_15_1] = nil
		var_15_0.all_disabled_units[var_15_1] = arg_15_0

		arg_15_0:_stop(true)
	else
		var_15_0.all_update_units[var_15_1] = arg_15_0
		var_15_0.all_disabled_units[var_15_1] = nil

		local var_15_2 = var_0_0[var_15_1]

		arg_15_0._pos_lerp_time = 0

		Unit.set_data(var_15_1, "last_lerp_position", var_15_2)
		Unit.set_data(var_15_1, "last_lerp_position_offset", Vector3(0, 0, 0))
		Unit.set_data(var_15_1, "accumulated_movement", Vector3(0, 0, 0))

		if not arg_15_4 then
			arg_15_0:set_wanted_velocity(Vector3.zero())
			arg_15_0:move_to_non_intersecting_position()
		end
	end
end

function PlayerUnitLocomotionExtension.set_mover_disable_reason(arg_16_0, arg_16_1, arg_16_2)
	MoverHelper.set_disable_reason(arg_16_0.unit, arg_16_0.mover_state, arg_16_1, arg_16_2)
end

function PlayerUnitLocomotionExtension.set_active_mover(arg_17_0, arg_17_1)
	MoverHelper.set_active_mover(arg_17_0.unit, arg_17_0.mover_state, arg_17_1)
end

function PlayerUnitLocomotionExtension.post_update(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	local var_18_0 = arg_18_0.on_ground and Vector3.length(arg_18_0.velocity_current:unbox()) or 0
	local var_18_1 = arg_18_0.anim_move_speed
	local var_18_2 = math.abs(var_18_1 - var_18_0)

	if var_18_1 < var_18_0 then
		local var_18_3 = math.min(var_18_0 / var_0_2 * arg_18_3, var_18_2)

		var_18_1 = math.clamp(var_18_1 + var_18_3, 0, var_18_0)
		arg_18_0._move_speed_top = var_18_1
	else
		local var_18_4 = arg_18_0._move_speed_top or var_18_0
		local var_18_5 = math.min(var_18_4 / var_0_2 * arg_18_3, var_18_2)

		var_18_1 = math.clamp(var_18_1 - var_18_5, 0, var_18_1)
	end

	arg_18_0.anim_move_speed = var_18_1

	arg_18_0.first_person_extension:animation_set_variable("move_speed", math.min(var_18_1, var_0_1), true)
	arg_18_0.third_person_idle_fullbody_animation_control:update(arg_18_5)

	if script_data.debug_player_skeletons then
		local var_18_6 = Unit.bones(arg_18_1)

		for iter_18_0, iter_18_1 in ipairs(var_18_6) do
			if Unit.has_node(arg_18_1, iter_18_1) then
				local var_18_7 = Unit.node(arg_18_1, iter_18_1)
				local var_18_8 = Unit.scene_graph_parent(arg_18_1, var_18_7)

				if var_18_8 then
					local var_18_9 = Unit.world_position(arg_18_1, var_18_8)
					local var_18_10 = Unit.world_position(arg_18_1, var_18_7)
					local var_18_11 = Vector3.distance(var_18_9, var_18_10) / 10

					if var_18_11 > 0.1 then
						var_18_11 = 0.1
					end

					local var_18_12 = Color(100, 100, 255)

					if iter_18_1 == arg_18_0.draw_node then
						var_18_12 = Color(255, 255, 0)
					end

					QuickDrawer:cone(var_18_9, var_18_10, var_18_11, var_18_12, 20, 5)
				end
			end
		end
	end
end

function PlayerUnitLocomotionExtension.moving_on_slope(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	if arg_19_0.is_bot then
		arg_19_0.allow_jump = true

		return false
	end

	local var_19_0 = PlayerUnitMovementSettings.slope_traversion.max_angle

	Mover.set_max_slope_angle(arg_19_3, var_19_0)

	local var_19_1 = Mover.actor_colliding_down(arg_19_3)
	local var_19_2 = true

	if var_19_1 then
		local var_19_3 = Actor.unit(var_19_1)

		if not Unit.alive(var_19_3) or not Unit.get_data(var_19_3, "slippery") then
			var_19_2 = false
		end
	end

	local var_19_4 = Mover.standing_frames(arg_19_3) == 0 or var_19_2

	arg_19_0.allow_jump = not arg_19_1 or arg_19_0.allow_jump and arg_19_0.on_ground or Mover.flying_frames(arg_19_3) == 0 and not var_19_2

	return var_19_4 and arg_19_1
end

local var_0_4 = {}

function PlayerUnitLocomotionExtension.update_script_driven_movement(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	if arg_20_0._script_movement_time_scale then
		arg_20_2 = arg_20_2 * arg_20_0._script_movement_time_scale
		arg_20_0._script_movement_time_scale = nil
	end

	local var_20_0 = arg_20_0.external_velocity and arg_20_0.external_velocity:unbox()
	local var_20_1 = arg_20_0.velocity_current:unbox() + Vector3(0, 0, var_20_0 and var_20_0.z or 0)
	local var_20_2 = arg_20_0.velocity_wanted:unbox()
	local var_20_3 = Unit.mover(arg_20_1)

	if arg_20_4 then
		var_20_2.z = var_20_1.z
	end

	if arg_20_0._dirty_forced_velocity then
		var_20_2 = arg_20_0._velocity_forced:unbox()

		arg_20_0._velocity_forced:store(Vector3.zero())

		arg_20_0._dirty_forced_velocity = false
	end

	local var_20_4
	local var_20_5

	if var_20_0 then
		local var_20_6 = Vector3.flat(var_20_0)

		var_20_4 = Vector3.normalize(var_20_6)

		local var_20_7 = Vector3.length(var_20_6)
		local var_20_8 = Vector3.dot(var_20_4, var_20_2)

		if var_20_7 < var_20_8 then
			-- block empty
		elseif var_20_8 > 0 then
			var_20_2 = var_20_2 - var_20_4 * var_20_8 + var_20_6
		else
			var_20_6 = var_20_6 + var_20_4 * var_20_8 * arg_20_2
			var_20_2 = var_20_2 - var_20_4 * var_20_8 + var_20_6
		end

		if arg_20_0.on_ground then
			local var_20_9 = 15

			var_20_5 = var_20_6 + math.min(var_20_9 * arg_20_2, var_20_7) * -var_20_4
		else
			var_20_5 = var_20_6 * (1 - math.min(arg_20_2 * 0.00225 * var_20_7 * var_20_7, 1))
		end

		if Vector3.length(var_20_5) < 0.01 then
			arg_20_0.external_velocity = nil
		else
			arg_20_0.external_velocity:store(var_20_5)
		end
	end

	local var_20_10 = arg_20_0.use_drag and 0.00255 or 1
	local var_20_11 = Vector3.length(var_20_2)
	local var_20_12 = var_20_2 + var_20_10 * var_20_11 * var_20_11 * Vector3.normalize(-var_20_2) * arg_20_2

	if arg_20_4 then
		local var_20_13 = var_20_12.z - PlayerUnitMovementSettings.get_movement_settings_table(arg_20_1).gravity_acceleration * arg_20_0._script_driven_gravity_scale * arg_20_2

		var_20_12.z = math.min(arg_20_0.maximum_upward_velocity, var_20_13)
	end

	local var_20_14 = Vector3.length(var_20_12)
	local var_20_15 = Unit.local_position(arg_20_1, 0)
	local var_20_16 = Vector3.flat(var_20_12)
	local var_20_17 = Vector3.length(var_20_16)

	if var_20_17 > 0.001 then
		var_20_16 = var_20_16 / var_20_17

		local var_20_18 = Vector3.flat(var_20_15)
		local var_20_19
		local var_20_20 = -1
		local var_20_21 = 1
		local var_20_22 = 1
		local var_20_23 = var_20_15 + var_20_16 * 0.5
		local var_20_24 = arg_20_0._mover_modes.enemy_noclip == true
		local var_20_25 = not arg_20_0._pactsworn_no_clip and not var_20_24
		local var_20_26 = arg_20_0._no_clip_filter

		if var_20_25 then
			local var_20_27 = AiUtils.broadphase_query(var_20_23, var_20_22, var_0_4)

			for iter_20_0 = 1, var_20_27 do
				local var_20_28 = var_0_4[iter_20_0]
				local var_20_29 = ScriptUnit.extension(var_20_28, "ai_system")._breed
				local var_20_30 = HEALTH_ALIVE[var_20_28]
				local var_20_31 = ScriptUnit.extension(var_20_28, "ai_system")

				if var_20_30 and var_20_31.player_locomotion_constrain_radius ~= nil and not var_20_26[var_20_29.armor_category] then
					local var_20_32 = var_20_31.player_locomotion_constrain_radius
					local var_20_33 = var_20_32 * var_20_32 * 2 * 2
					local var_20_34 = Vector3.flat(var_0_0[var_20_28])
					local var_20_35 = var_20_18 + var_20_16

					if var_20_33 > Vector3.distance_squared(var_20_34, var_20_35) then
						var_20_19 = var_20_34 + Vector3.normalize(var_20_35 - var_20_34) * var_20_32 * 2

						local var_20_36 = Vector3.dot(var_20_16, Vector3.normalize(var_20_19 - var_20_18))

						var_20_20 = math.max(var_20_20, var_20_36)
						var_20_21 = math.min(var_20_21, var_20_36)
					end
				end
			end
		end

		if var_20_21 < var_20_20 or var_20_21 <= 0 then
			var_20_12.z, var_20_12 = var_20_12.z, Vector3.zero()
		elseif var_20_19 then
			local var_20_37 = var_20_12.z

			var_20_12 = var_20_19 - var_20_18

			if Vector3.length(var_20_12) > 0.001 then
				var_20_12 = Vector3.normalize(var_20_12) * var_20_14 * var_20_21
			end

			var_20_12.z = var_20_37
		end
	else
		local var_20_38 = Vector3.flat(var_20_15)
		local var_20_39 = 1
		local var_20_40 = var_20_15 + var_20_16 * 0.5
		local var_20_41 = arg_20_0._mover_modes.enemy_noclip == true

		if not arg_20_0._pactsworn_no_clip and not var_20_41 then
			local var_20_42 = AiUtils.broadphase_query(var_20_40, var_20_39, var_0_4)

			for iter_20_1 = 1, var_20_42 do
				local var_20_43 = var_0_4[iter_20_1]
				local var_20_44 = HEALTH_ALIVE[var_20_43]
				local var_20_45 = ScriptUnit.extension(var_20_43, "ai_system")

				if var_20_44 and var_20_45.player_locomotion_constrain_radius ~= nil then
					local var_20_46 = var_20_45.player_locomotion_constrain_radius
					local var_20_47 = Vector3.flat(var_0_0[var_20_43])
					local var_20_48 = var_20_46 * var_20_46
					local var_20_49 = Vector3.distance_squared(var_20_47, var_20_38)

					if var_20_49 < var_20_48 then
						local var_20_50 = 2 * (1 - var_20_49 / var_20_48)

						var_20_12 = var_20_12 + Vector3.normalize(var_20_38 - var_20_47) * var_20_50
					end
				end
			end
		end
	end

	local var_20_51 = var_20_12 * arg_20_2

	Mover.move(var_20_3, var_20_51, arg_20_2)

	local var_20_52 = Mover.position(var_20_3)
	local var_20_53 = (var_20_52 - var_20_15) / arg_20_2
	local var_20_54 = Vector3.copy(var_20_53)

	if arg_20_0._platform_extension and Mover.flying_frames(var_20_3) <= 1 then
		var_20_54[3] = 0
	end

	arg_20_0.velocity_network:store(var_20_54)
	Unit.set_local_position(arg_20_1, 0, var_20_52)

	if arg_20_0:moving_on_slope(arg_20_4, arg_20_1, var_20_3, var_20_52) then
		var_20_53.z = var_20_12.z
	end

	if arg_20_0.external_velocity then
		local var_20_55 = Vector3.dot(var_20_53, var_20_4)

		if var_20_55 < Vector3.length(var_20_5) then
			arg_20_0.external_velocity:store(var_20_55 * var_20_4)
		end
	end

	arg_20_0.velocity_current:store(var_20_53)
end

function PlayerUnitLocomotionExtension.update_animation_driven_movement(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = Unit.animation_wanted_root_pose(arg_21_1)
	local var_21_1 = Matrix4x4.translation(var_21_0)
	local var_21_2 = var_0_0[arg_21_1]
	local var_21_3 = var_21_1 - var_21_2
	local var_21_4 = Vector3.multiply_elements(var_21_3, arg_21_0.animation_translation_scale:unbox())
	local var_21_5
	local var_21_6 = arg_21_0.velocity_current:unbox()
	local var_21_7 = Vector3(0, 0, var_21_6.z)

	if arg_21_0.ignore_gravity then
		var_21_5 = var_21_4
	else
		var_21_7.z = var_21_7.z - 9.82 * arg_21_2
		var_21_5 = var_21_7 * arg_21_2 + var_21_4
	end

	local var_21_8 = Unit.mover(arg_21_1)

	Mover.move(var_21_8, var_21_5, arg_21_2)

	local var_21_9 = Mover.position(var_21_8)

	Unit.set_local_position(arg_21_1, 0, var_21_9)

	local var_21_10 = (Vector3(var_21_1.x, var_21_1.y, var_21_9.z) - var_21_2) / arg_21_2

	if not arg_21_0.ignore_gravity and arg_21_0:moving_on_slope(true, arg_21_1, var_21_8, var_21_9) then
		var_21_10.z = var_21_7.z
	end

	var_21_10.z = math.min(0, var_21_10.z)

	arg_21_0.velocity_network:store(var_21_10)
	arg_21_0.velocity_current:store(var_21_10)
end

function PlayerUnitLocomotionExtension.set_animation_translation_scale(arg_22_0, arg_22_1)
	arg_22_0.animation_translation_scale:store(arg_22_1)
end

function PlayerUnitLocomotionExtension.get_animation_translation_scale(arg_23_0)
	return arg_23_0.animation_translation_scale:unbox()
end

function PlayerUnitLocomotionExtension.update_animation_driven_movement_no_mover(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = Unit.animation_wanted_root_pose(arg_24_1)
	local var_24_1 = Matrix4x4.translation(var_24_0)
	local var_24_2 = var_0_0[arg_24_1]
	local var_24_3 = var_24_1 - var_24_2
	local var_24_4 = Vector3.multiply_elements(var_24_3, arg_24_0.animation_translation_scale:unbox())
	local var_24_5 = var_24_4 / arg_24_2

	Unit.set_local_position(arg_24_1, 0, var_24_2 + var_24_4)
	arg_24_0.velocity_network:store(var_24_5)
	arg_24_0.velocity_current:store(var_24_5)
end

function PlayerUnitLocomotionExtension.update_animation_driven_movement_with_rotation_no_mover(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	arg_25_0:update_animation_driven_movement_no_mover(arg_25_1, arg_25_2, arg_25_3)

	local var_25_0 = Unit.animation_wanted_root_pose(arg_25_1)
	local var_25_1 = Matrix4x4.rotation(var_25_0)

	Unit.set_local_rotation(arg_25_1, 0, var_25_1)
end

function PlayerUnitLocomotionExtension.update_animation_driven_movement_entrance_and_exit_no_mover(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	arg_26_0:update_animation_driven_movement_no_mover(arg_26_1, arg_26_2, arg_26_3)

	local var_26_0 = arg_26_0._climb_exit:unbox()
	local var_26_1 = arg_26_0._climb_entrance:unbox()
	local var_26_2 = Vector3.normalize(Vector3.flat(var_26_0 - var_26_1))
	local var_26_3 = Quaternion.look(var_26_2)

	Unit.set_local_rotation(arg_26_1, 0, var_26_3)
end

function PlayerUnitLocomotionExtension.update_script_driven_ladder_transition_movement(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = Unit.animation_wanted_root_pose(arg_27_1)
	local var_27_1, var_27_2 = Matrix4x4.translation(var_27_0), var_0_0[arg_27_1]
	local var_27_3 = Unit.mover(arg_27_1)
	local var_27_4 = var_27_1 - var_27_2

	Mover.move(var_27_3, var_27_4, arg_27_2)

	local var_27_5 = Mover.position(var_27_3)
	local var_27_6 = var_27_1 - var_27_5

	Unit.set_local_position(arg_27_1, 0, var_27_5)

	local var_27_7 = (var_27_1 - var_27_2) / arg_27_2

	arg_27_0.velocity_network:store(var_27_7)
	arg_27_0.velocity_current:store(var_27_7)
	arg_27_0.old_error:store(var_27_6)
end

function PlayerUnitLocomotionExtension.update_linked_movement(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = arg_28_0.link_data
	local var_28_1 = var_28_0.unit
	local var_28_2 = var_28_0.node
	local var_28_3 = var_28_0.offset:unbox()
	local var_28_4 = Unit.world_position(var_28_1, var_28_2) + var_28_3

	Unit.set_local_position(arg_28_1, 0, var_28_4)

	local var_28_5 = Vector3.zero()

	arg_28_0.velocity_network:store(var_28_5)
	arg_28_0.velocity_current:store(var_28_5)
end

function PlayerUnitLocomotionExtension.update_script_driven_no_mover_movement(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_0.velocity_wanted:unbox()
	local var_29_1 = var_0_0[arg_29_1] + var_29_0 * arg_29_2

	Unit.set_local_position(arg_29_1, 0, var_29_1)
	arg_29_0.velocity_network:store(var_29_0)
	arg_29_0.velocity_current:store(var_29_0)
end

function PlayerUnitLocomotionExtension.update_wanted_position_movement(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = var_0_0[arg_30_1]
	local var_30_1 = arg_30_0.wanted_position:unbox() - var_30_0
	local var_30_2 = arg_30_0.velocity_current:unbox()
	local var_30_3 = Vector3(0, 0, var_30_2.z)

	var_30_3.z = var_30_3.z - 9.82 * arg_30_2

	local var_30_4 = var_30_1 + var_30_3
	local var_30_5 = Unit.mover(arg_30_1)

	Mover.move(var_30_5, var_30_4, arg_30_2)

	local var_30_6 = Mover.position(var_30_5)

	Unit.set_local_position(arg_30_1, 0, var_30_6)
end

function PlayerUnitLocomotionExtension.set_disable_rotation_update(arg_31_0)
	arg_31_0.disable_rotation_update = true
end

function PlayerUnitLocomotionExtension.set_stood_still_target_rotation(arg_32_0, arg_32_1)
	arg_32_0.target_rotation:store(arg_32_1)

	local var_32_0 = Vector3.flat(Quaternion.forward(arg_32_1))
	local var_32_1 = Quaternion.look(var_32_0)

	Unit.set_local_rotation(arg_32_0.unit, 0, var_32_1)
end

function PlayerUnitLocomotionExtension.is_stood_still(arg_33_0)
	local var_33_0 = arg_33_0.first_person_extension:current_rotation()
	local var_33_1 = Vector3.flat(Quaternion.forward(var_33_0))
	local var_33_2 = arg_33_0.velocity_current:unbox()

	var_33_2.z = 0

	return Vector3.dot(var_33_2, var_33_1) == 0
end

function PlayerUnitLocomotionExtension.sync_network_rotation(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = Unit.local_rotation(arg_34_0.unit, 0)
	local var_34_1 = Quaternion.yaw(var_34_0)
	local var_34_2 = Quaternion.pitch(var_34_0)

	GameSession.set_game_object_field(arg_34_1, arg_34_2, "yaw", var_34_1)
	GameSession.set_game_object_field(arg_34_1, arg_34_2, "pitch", var_34_2)
end

function PlayerUnitLocomotionExtension.sync_network_position(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = Unit.local_position(arg_35_0.unit, 0)

	if arg_35_0._platform_unit then
		var_35_0 = var_35_0 - Unit.local_position(arg_35_0._platform_unit, 0)
	end

	local var_35_1 = NetworkConstants.position
	local var_35_2 = var_35_1.min
	local var_35_3 = var_35_1.max

	GameSession.set_game_object_field(arg_35_1, arg_35_2, "position", Vector3.clamp(var_35_0, var_35_2, var_35_3))
end

function PlayerUnitLocomotionExtension.sync_network_velocity(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	local var_36_0 = arg_36_0.velocity_network:unbox()
	local var_36_1 = NetworkConstants.velocity.min
	local var_36_2 = NetworkConstants.velocity.max

	GameSession.set_game_object_field(arg_36_1, arg_36_2, "velocity", Vector3.clamp(var_36_0, var_36_1, var_36_2))
	GameSession.set_game_object_field(arg_36_1, arg_36_2, "average_velocity", Vector3.clamp(arg_36_0._average_velocity:unbox(), var_36_1, var_36_2))
end

function PlayerUnitLocomotionExtension.set_wanted_velocity(arg_37_0, arg_37_1)
	if not arg_37_0.disabled and (arg_37_0.state == "script_driven" or arg_37_0.state == "script_driven_ladder" or arg_37_0.state == "script_driven_no_mover" or arg_37_0.state == "script_driven_ladder_transition_movement") then
		arg_37_0.velocity_wanted:store(arg_37_1)
	end
end

function PlayerUnitLocomotionExtension.set_script_movement_time_scale(arg_38_0, arg_38_1)
	arg_38_0._script_movement_time_scale = arg_38_1
end

function PlayerUnitLocomotionExtension.set_script_driven_gravity_scale(arg_39_0, arg_39_1)
	arg_39_0._script_driven_gravity_scale = arg_39_1
end

function PlayerUnitLocomotionExtension.get_script_driven_gravity_scale(arg_40_0, arg_40_1)
	return arg_40_0._script_driven_gravity_scale
end

function PlayerUnitLocomotionExtension.add_external_velocity(arg_41_0, arg_41_1, arg_41_2)
	if not arg_41_0._external_velocity_enabled then
		return
	end

	if not arg_41_0.external_velocity then
		arg_41_0.external_velocity = Vector3Box()
	end

	local var_41_0 = arg_41_0.external_velocity:unbox()
	local var_41_1 = arg_41_2 or 5
	local var_41_2 = Vector3.dot(var_41_0, Vector3.normalize(arg_41_1))
	local var_41_3 = var_41_0 + arg_41_1 * ((var_41_1 - math.clamp(var_41_2, 0, var_41_1)) / var_41_1)

	arg_41_0.external_velocity:store(var_41_3)
end

function PlayerUnitLocomotionExtension.set_forced_velocity(arg_42_0, arg_42_1)
	if not arg_42_0.disabled and (arg_42_0.state == "script_driven" or arg_42_0.state == "script_driven_ladder") then
		if arg_42_1 then
			arg_42_0._velocity_forced:store(arg_42_0._velocity_forced:unbox() + arg_42_1)

			arg_42_0._dirty_forced_velocity = true
		else
			arg_42_0._velocity_forced:store(Vector3.zero())

			arg_42_0._dirty_forced_velocity = false
		end
	end
end

function PlayerUnitLocomotionExtension.set_external_velocity_enabled(arg_43_0, arg_43_1)
	arg_43_0._external_velocity_enabled = arg_43_1

	if arg_43_0.external_velocity and not arg_43_1 then
		arg_43_0.external_velocity = nil
	end
end

function PlayerUnitLocomotionExtension.set_maximum_upwards_velocity(arg_44_0, arg_44_1)
	arg_44_0.maximum_upward_velocity = arg_44_1
end

function PlayerUnitLocomotionExtension.reset_maximum_upwards_velocity(arg_45_0)
	arg_45_0.maximum_upward_velocity = 0
end

function PlayerUnitLocomotionExtension.set_speed_multiplier(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	arg_46_0.speed_multiplier = arg_46_1
	arg_46_0.speed_multiplier_start_time = arg_46_2
	arg_46_0.speed_multiplier_duration = arg_46_3
end

function PlayerUnitLocomotionExtension.current_speed_multiplier(arg_47_0)
	return arg_47_0.speed_multiplier
end

function PlayerUnitLocomotionExtension.jump_allowed(arg_48_0)
	return arg_48_0.allow_jump
end

function PlayerUnitLocomotionExtension.current_velocity(arg_49_0)
	return arg_49_0.velocity_current and arg_49_0.velocity_current:unbox()
end

function PlayerUnitLocomotionExtension.current_rotation(arg_50_0)
	return arg_50_0.first_person_extension:current_rotation()
end

function PlayerUnitLocomotionExtension.current_relative_velocity(arg_51_0)
	local var_51_0 = arg_51_0.first_person_extension
	local var_51_1 = arg_51_0.velocity_current:unbox()
	local var_51_2 = var_51_0:current_rotation()
	local var_51_3 = Quaternion.inverse(var_51_2)

	return (Quaternion.rotate(var_51_3, var_51_1))
end

function PlayerUnitLocomotionExtension.current_relative_velocity_3p(arg_52_0)
	local var_52_0 = arg_52_0.unit
	local var_52_1 = arg_52_0.velocity_current:unbox()
	local var_52_2 = Unit.local_rotation(var_52_0, 0)
	local var_52_3 = Quaternion.inverse(var_52_2)

	return (Quaternion.rotate(var_52_3, var_52_1))
end

function PlayerUnitLocomotionExtension.enable_linked_movement(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	arg_53_0.state = "linked_movement"
	arg_53_0.link_data = {
		unit = arg_53_1,
		node = arg_53_2,
		offset = Vector3Box(arg_53_3)
	}

	local var_53_0 = arg_53_0.unit
	local var_53_1 = Managers.state.network
	local var_53_2 = var_53_1:game()
	local var_53_3 = Managers.state.unit_storage:go_id(var_53_0)

	if var_53_2 and var_53_3 then
		local var_53_4, var_53_5 = var_53_1:game_object_or_level_id(arg_53_1)

		GameSession.set_game_object_field(var_53_2, var_53_3, "linked_movement", true)
		GameSession.set_game_object_field(var_53_2, var_53_3, "link_parent_id", var_53_4)
		GameSession.set_game_object_field(var_53_2, var_53_3, "link_parent_is_level_unit", var_53_5)
		GameSession.set_game_object_field(var_53_2, var_53_3, "link_node", arg_53_2)
		GameSession.set_game_object_field(var_53_2, var_53_3, "link_offset", arg_53_3)
	end
end

function PlayerUnitLocomotionExtension.disable_linked_movement(arg_54_0)
	local var_54_0 = arg_54_0.unit
	local var_54_1 = Managers.state.network:game()
	local var_54_2 = Managers.state.unit_storage:go_id(var_54_0)

	if var_54_1 and var_54_2 then
		GameSession.set_game_object_field(var_54_1, var_54_2, "linked_movement", false)
	end
end

function PlayerUnitLocomotionExtension.enable_animation_driven_movement(arg_55_0, arg_55_1)
	arg_55_0.ignore_gravity = arg_55_1
	arg_55_0.state = "animation_driven"
end

function PlayerUnitLocomotionExtension.enable_animation_driven_movement_entrance_and_exit_no_mover(arg_56_0, arg_56_1, arg_56_2)
	arg_56_0._climb_entrance = Vector3Box(arg_56_1)
	arg_56_0._climb_exit = Vector3Box(arg_56_2)
	arg_56_0.state = "animation_driven_entrance_and_exit_no_mover"
end

function PlayerUnitLocomotionExtension.enable_animation_driven_movement_with_rotation_no_mover(arg_57_0)
	arg_57_0.state = "animation_driven_with_rotation_no_mover"
end

function PlayerUnitLocomotionExtension.enable_script_driven_movement(arg_58_0)
	arg_58_0._dirty_forced_velocity = false
	arg_58_0._script_movement_time_scale = nil
	arg_58_0.state = "script_driven"
end

function PlayerUnitLocomotionExtension.enable_script_driven_ladder_movement(arg_59_0)
	arg_59_0._dirty_forced_velocity = false
	arg_59_0._script_movement_time_scale = nil
	arg_59_0.state = "script_driven_ladder"

	arg_59_0:set_wanted_velocity(Vector3.zero())
end

function PlayerUnitLocomotionExtension.enable_script_driven_ladder_transition_movement(arg_60_0)
	arg_60_0.state = "script_driven_ladder_transition_movement"
	arg_60_0.old_error = Vector3Box(0, 0, 0)
end

function PlayerUnitLocomotionExtension.enable_script_driven_no_mover_movement(arg_61_0)
	arg_61_0.state = "script_driven_no_mover"
end

function PlayerUnitLocomotionExtension.enable_wanted_position_movement(arg_62_0, arg_62_1, arg_62_2)
	arg_62_0:_stop(false)

	arg_62_0.state = "wanted_position_mover"
end

function PlayerUnitLocomotionExtension.is_animation_driven(arg_63_0)
	return arg_63_0.state == "animation_driven"
end

function PlayerUnitLocomotionExtension.is_linked_movement(arg_64_0)
	return arg_64_0.state == "linked_movement"
end

function PlayerUnitLocomotionExtension.is_script_driven_ladder(arg_65_0)
	return arg_65_0.state == "script_driven_ladder"
end

function PlayerUnitLocomotionExtension.is_script_driven_ladder_transition(arg_66_0)
	return arg_66_0.state == "script_driven_ladder_transition_movement"
end

function PlayerUnitLocomotionExtension.get_link_data(arg_67_0)
	return arg_67_0.link_data
end

function PlayerUnitLocomotionExtension.is_colliding_down(arg_68_0)
	return arg_68_0.collides_down
end

function PlayerUnitLocomotionExtension.force_on_ground(arg_69_0, arg_69_1)
	arg_69_0.on_ground = arg_69_1
end

function PlayerUnitLocomotionExtension.is_on_ground(arg_70_0)
	return arg_70_0.on_ground
end

function PlayerUnitLocomotionExtension.set_wanted_pos(arg_71_0, arg_71_1)
	arg_71_0.wanted_position:store(arg_71_1)
end

function PlayerUnitLocomotionExtension.teleport_to(arg_72_0, arg_72_1, arg_72_2)
	local var_72_0 = arg_72_0.unit
	local var_72_1 = Unit.mover(var_72_0)

	Mover.set_position(var_72_1, arg_72_1)
	Unit.set_local_position(var_72_0, 0, arg_72_1)

	if arg_72_2 ~= nil then
		arg_72_0.first_person_extension:set_rotation(arg_72_2)
	end

	if IS_WINDOWS and not arg_72_0.player.bot_player then
		Application.reset_dlss()
	end

	arg_72_0:move_to_non_intersecting_position()
	arg_72_0.status_extension:set_ignore_next_fall_damage(true)
	arg_72_0.status_extension:set_falling_height()
end

function PlayerUnitLocomotionExtension.enable_rotation_towards_velocity(arg_73_0, arg_73_1, arg_73_2, arg_73_3)
	arg_73_0.rotate_along_direction = arg_73_1

	if arg_73_1 then
		arg_73_0.target_rotation_data = nil
	elseif arg_73_2 then
		assert(arg_73_3, "Tried to set target rotation without setting duration")

		local var_73_0 = Managers.time:time("game")

		arg_73_0.target_rotation_data = {
			target_rotation = QuaternionBox(arg_73_2),
			start_rotation = QuaternionBox(Unit.local_rotation(arg_73_0.unit, 0)),
			start_time = var_73_0,
			end_time = var_73_0 + arg_73_3
		}
	end
end

function PlayerUnitLocomotionExtension.enable_drag(arg_74_0, arg_74_1)
	arg_74_0.use_drag = arg_74_1
end

local var_0_5 = 6

function PlayerUnitLocomotionExtension.apply_no_clip_filter(arg_75_0, arg_75_1, arg_75_2)
	for iter_75_0 = 1, var_0_5 do
		if arg_75_1[iter_75_0] then
			if not arg_75_0._no_clip_filter[iter_75_0] then
				arg_75_0._no_clip_filter[iter_75_0] = {
					[arg_75_2] = true
				}
			else
				arg_75_0._no_clip_filter[iter_75_0][arg_75_2] = true
			end
		end
	end
end

function PlayerUnitLocomotionExtension.remove_no_clip_filter(arg_76_0, arg_76_1)
	local var_76_0 = arg_76_0._no_clip_filter

	for iter_76_0 = 1, var_0_5 do
		local var_76_1 = var_76_0[iter_76_0]

		if var_76_1 then
			var_76_1[arg_76_1] = nil

			if table.is_empty(var_76_1) then
				var_76_0[iter_76_0] = nil
			end
		end
	end
end
